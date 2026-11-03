# ================================================================
# Filter AZs from particular region - Exclude "Local Zone" option
# =================================================================
data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

# ================================================================
# Lookup the latest AMI of Amazon Linux ARM
# =================================================================
data "aws_ssm_parameter" "al2023_arm64" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
}

#==============================================
# References to remote terraform secrets state
#===============================================
data "terraform_remote_state" "secrets" {
  backend = "s3"
  config = {
    bucket = "capstone-terraform-state-249899229305-ap-southeast-1-an"
    key    = "secrets/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

#=====================================================
# References to remote terraform legacy network state
#=====================================================
data "terraform_remote_state" "legacy_network" {
  backend = "s3"
  config = {
    bucket = "capstone-terraform-state-249899229305-ap-southeast-1-an"
    key    = "legacy-network/terraform.tfstate"
    region = "ap-southeast-1"
  }
}