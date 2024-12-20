# AWS account config
region = "eu-central-1"

# General for all infrastructure
# This is the name prefix for all infra components
name = "yevhent"


#vpc_id      = "vpc-06ae62935ffb33e2b"
#subnets_ids = ["subnet-0b27929ad2896d99f", "subnet-0c15a8c6856de7853", "subnet-01a5c422124b1c69e"]


vpc_id      = "vpc-03b5ab701ad62483a"
subnets_ids = ["subnet-07b489a2e1efe497f", "subnet-0340028001abca9af", "subnet-020c0486dd154cee3"]

tags = {
  Environment = "test-yevhent"
  TfControl   = "true"
}

zone_name = "devops4.test-danit.com"
