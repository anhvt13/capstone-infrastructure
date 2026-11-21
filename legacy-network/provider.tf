provider "aws" {
  alias  = "primary"
  region = var.primary_aws_region
}

provider "aws" {
  alias  = "dr"
  region = var.dr_aws_region
}
