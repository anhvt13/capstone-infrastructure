terraform {
  backend "s3" {
    bucket       = "capstone-terraform-state-249899229305-ap-southeast-1-an"
    key          = "infras/terraform.tfstate"
    region       = "ap-southeast-1"
    use_lockfile = true
  }
}
