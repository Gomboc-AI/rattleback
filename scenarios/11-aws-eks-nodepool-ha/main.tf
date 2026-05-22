data "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"
}

data "aws_iam_role" "eks_node" {
  name = "eks-node-role"
}

# EKS cluster: arn:aws:eks:us-east-1:123456789012:cluster/prod-cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = data.aws_iam_role.eks_cluster.arn
  version  = "1.29"

  vpc_config {
    subnet_ids = [
      var.subnet_ids["us-east-1a"],
      var.subnet_ids["us-east-1b"],
    ]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Environment = "production"
    Team        = "platform-engineering"
    CostCenter  = "pe-2001"
    ManagedBy   = "terraform"
  }
}

# Node group: arn:aws:eks:us-east-1:123456789012:nodegroup/prod-cluster/system-pool/abc123
resource "aws_eks_node_group" "system" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "system-pool"
  node_role_arn   = data.aws_iam_role.eks_node.arn

  subnet_ids = [
    var.subnet_ids["us-east-1a"],
    var.subnet_ids["us-east-1b"],
  ]

  instance_types = ["m5.xlarge"]

  scaling_config {
    min_size     = var.system_node_min_size
    max_size     = var.system_node_max_size
    desired_size = var.system_node_desired_size
  }

  labels = {
    "node-role"                       = "system"
    "cluster-autoscaler/enabled"      = "true"
    "cluster-autoscaler/prod-cluster" = "owned"
  }

  tags = {
    Environment                                     = "production"
    Team                                            = "platform-engineering"
    "k8s.io/cluster-autoscaler/enabled"             = "true"
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
  }
}

resource "aws_autoscaling_group_tag" "cas_enabled" {
  autoscaling_group_name = aws_eks_node_group.system.resources[0].autoscaling_groups[0].name

  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "true"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "cas_owned" {
  autoscaling_group_name = aws_eks_node_group.system.resources[0].autoscaling_groups[0].name

  tag {
    key                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}

# Cluster is migrating from CAS to Karpenter for workload scaling
resource "helm_release" "karpenter" {
  name             = "karpenter"
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  version          = "0.33.1"
  namespace        = "karpenter"
  create_namespace = true

  set {
    name  = "settings.clusterName"
    value = aws_eks_cluster.main.name
  }

  set {
    name  = "settings.clusterEndpoint"
    value = aws_eks_cluster.main.endpoint
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::123456789012:role/karpenter-controller"
  }
}

# Karpenter NodePool: general-workload
resource "kubernetes_manifest" "karpenter_nodepool" {
  manifest = {
    apiVersion = "karpenter.sh/v1beta1"
    kind       = "NodePool"
    metadata = {
      name = "general-workload"
    }
    spec = {
      template = {
        spec = {
          requirements = [
            {
              key      = "karpenter.k8s.aws/instance-type"
              operator = "In"
              values   = ["m5.xlarge", "m5.2xlarge", "c5.xlarge", "c5.2xlarge"]
            },
            {
              key      = "topology.kubernetes.io/zone"
              operator = "In"
              values   = ["us-east-1a", "us-east-1b"]
            },
            {
              key      = "karpenter.sh/capacity-type"
              operator = "In"
              values   = ["on-demand", "spot"]
            },
          ]
          nodeClassRef = {
            name = "default"
          }
        }
      }
      limits = {
        cpu    = "100"
        memory = "400Gi"
      }
      disruption = {
        consolidationPolicy = "WhenUnderutilized"
        expireAfter         = "720h"
      }
    }
  }

  depends_on = [helm_release.karpenter]
}

# Karpenter EC2NodeClass: default
resource "kubernetes_manifest" "karpenter_ec2nodeclass" {
  manifest = {
    apiVersion = "karpenter.k8s.aws/v1beta1"
    kind       = "EC2NodeClass"
    metadata = {
      name = "default"
    }
    spec = {
      amiFamily = "AL2"
      subnetSelectorTerms = [
        {
          tags = {
            "karpenter.sh/discovery"      = var.cluster_name
            "topology.kubernetes.io/zone" = "us-east-1a"
          }
        },
        {
          tags = {
            "karpenter.sh/discovery"      = var.cluster_name
            "topology.kubernetes.io/zone" = "us-east-1b"
          }
        },
      ]
      securityGroupSelectorTerms = [
        {
          tags = {
            "karpenter.sh/discovery" = var.cluster_name
          }
        },
      ]
      role = "karpenter-node-role"
      tags = {
        Environment = "production"
        ManagedBy   = "karpenter"
      }
    }
  }

  depends_on = [helm_release.karpenter]
}
