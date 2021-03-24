/**
 * Copyright 2021 Taito United
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.network.vpc_id
}

data "aws_availability_zones" "available" {
}

module "network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.17.0"
  name    = "${var.name}-vpc"
  tags = merge(
    local.tags,
    var.kubernetes_name == "" ? {} : {
      "kubernetes.io/cluster/${var.kubernetes_name}" = "shared"
    },
  )

  cidr = "10.10.0.0/16"
  azs = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1],
    data.aws_availability_zones.available.names[2],
  ]

  private_subnets  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets   = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
  database_subnets = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]

  elasticache_subnets   = ["10.10.31.0/24", "10.10.32.0/24", "10.10.33.0/24"]
  # redshift_subnets    = ["10.10.41.0/24", "10.10.42.0/24", "10.10.43.0/24"]
  # intra_subnets       = ["10.10.51.0/24", "10.10.52.0/24", "10.10.53.0/24"]

  private_subnet_tags = merge(
    local.tags,
    {
      "tier" = "private"
    },
  )

  public_subnet_tags = merge(
    local.tags,
    {
      "tier" = "public"
    },
  )

  database_subnet_tags = merge(
    local.tags,
    {
      "tier" = "database"
    },
  )

  elasticache_subnet_tags = merge(
    local.tags,
    {
      "tier" = "elasticache"
    },
  )

  # create_database_subnet_group     = false
  # enable_dns_hostnames             = true
  # enable_dns_support               = true
  # enable_vpn_gateway               = true

  enable_nat_gateway = true
  single_nat_gateway = true
  # enable_dhcp_options              = true
  # dhcp_options_domain_name         = "service.consul"
  # dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]

  # VPC endpoint for S3
  enable_s3_endpoint = true

  # VPC endpoint for DynamoDB
  # enable_dynamodb_endpoint = true

  # VPC endpoint for SSM
  enable_ssm_endpoint                = true
  # ssm_endpoint_private_dns_enabled = true
  # TODO: proper security group
  ssm_endpoint_security_group_ids    = [ data.aws_security_group.default.id ]
  # ssm_endpoint_subnet_ids = ["..."]

  # VPC endpoint for SSMMESSAGES
  # enable_ssmmessages_endpoint              = true
  # ssmmessages_endpoint_private_dns_enabled = true
  # ssmmessages_endpoint_security_group_ids  = [ data.aws_security_group.default.id ]

  # VPC Endpoint for EC2
  # enable_ec2_endpoint              = true
  # ec2_endpoint_private_dns_enabled = true
  # ec2_endpoint_security_group_ids  = [ data.aws_security_group.default.id ]

  # VPC Endpoint for EC2MESSAGES
  # enable_ec2messages_endpoint              = true
  # ec2messages_endpoint_private_dns_enabled = true
  # ec2messages_endpoint_security_group_ids  = [ data.aws_security_group.default.id ]

  # VPC Endpoint for ECR API
  # enable_ecr_api_endpoint              = true
  # ecr_api_endpoint_private_dns_enabled = true
  # ecr_api_endpoint_security_group_ids  = [ data.aws_security_group.default.id ]

  # VPC Endpoint for ECR DKR
  # enable_ecr_dkr_endpoint              = true
  # ecr_dkr_endpoint_private_dns_enabled = true
  # ecr_dkr_endpoint_security_group_ids  = [ data.aws_security_group.default.id ]

  # VPC endpoint for KMS
  # enable_kms_endpoint              = true
  # kms_endpoint_private_dns_enabled = true
  # kms_endpoint_security_group_ids  = [ data.aws_security_group.default.id ]

  # kms_endpoint_subnet_ids = ["..."]
}
