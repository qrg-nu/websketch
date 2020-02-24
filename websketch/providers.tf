# =============================================================================

provider "aws" {
  profile = "default"
  region = var.region
  version = ">= 2.38.0"
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

# =============================================================================

provider "kubernetes" {
}

# =============================================================================