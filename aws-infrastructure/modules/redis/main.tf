resource "aws_security_group" "capstone-valkey-sg" {
  name        = "capstone-valkey-sg"
  description = "Security group for Elastic Cache Serverless Valkey"
  vpc_id      = var.capstone_vpc_id

  tags = merge(
    {
      Name = "capstone-valkey-sg"
    },
    var.redis_tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "capstone-valkey-inbound-from-private-sg" {
  security_group_id            = aws_security_group.capstone-valkey-sg.id
  referenced_security_group_id = var.capstone_private_security_group_id
  ip_protocol                  = "tcp"
  from_port                    = 6379
  to_port                      = 6379
}

resource "aws_elasticache_serverless_cache" "capstone-valkey-cache" {
  name                 = "capstone-valkey-cache"
  engine               = "valkey"
  major_engine_version = "7"
  description          = "Capstone serverless Valkey cache"
  subnet_ids           = var.capstone_private_subnet_ids
  security_group_ids = [
    aws_security_group.capstone-valkey-sg.id
  ]
  cache_usage_limits {
    data_storage {
      maximum = 1
      unit    = "GB"
    }
    ecpu_per_second {
      maximum = 1000
    }
  }
  daily_snapshot_time      = "17:00"
  snapshot_retention_limit = 1

  tags = merge(
    {
      Name = "capstone-valkey-cache"
    },
    var.redis_tags
  )
}
