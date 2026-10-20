variable "secret_tags" {
  type        = map(string)
  description = "Common tags applied to all secret resources"
  default = {
    Layer     = "secret"
    Project   = "capstone"
    ManagedBy = "terraform"
  }
}