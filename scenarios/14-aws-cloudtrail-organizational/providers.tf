terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Management account: 111111111111
provider "aws" {
  alias               = "management"
  region              = var.region
  allowed_account_ids = ["111111111111"]

  assume_role {
    role_arn     = "arn:aws:iam::111111111111:role/OrganizationAccountAccessRole"
    session_name = "terraform-acme-audit"
  }
}

# Member account: 222222222222 (acme-prod)
provider "aws" {
  alias               = "member_prod"
  region              = var.region
  allowed_account_ids = ["222222222222"]

  assume_role {
    role_arn     = "arn:aws:iam::222222222222:role/OrganizationAccountAccessRole"
    session_name = "terraform-acme-audit"
  }
}

# Member account: 333333333333 (acme-data)
provider "aws" {
  alias               = "member_data"
  region              = var.region
  allowed_account_ids = ["333333333333"]

  assume_role {
    role_arn     = "arn:aws:iam::333333333333:role/OrganizationAccountAccessRole"
    session_name = "terraform-acme-audit"
  }
}
