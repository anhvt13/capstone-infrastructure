# ================================================================
# Filter AZs from particular region - Exclude "Local Zone" option
# =================================================================
data "aws_availability_zones" "primary_availability_zones" {
  provider = aws.primary
  state    = "available"
  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

data "aws_availability_zones" "dr_availability_zones" {
  provider = aws.dr
  state    = "available"
  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}