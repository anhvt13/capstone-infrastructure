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
