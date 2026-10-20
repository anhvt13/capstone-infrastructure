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