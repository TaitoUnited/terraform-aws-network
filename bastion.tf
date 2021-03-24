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

resource "aws_iam_policy" "bastion" {
  name = "${var.name}-bastion"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

module "ssm-bastion" {
  count             = var.network.bastionHostEnabled ? 1 : 0

  source            = "JamesWoolfenden/ssm-bastion/aws"
  version           = "0.1.36"
  allowed_cidrs     = var.network.bastionAuthorizedCIDRs
  common_tags       = local.tags
  vpc_id            = module.network.vpc_id
  instance_type     = "t2.micro"
  ssm_standard_role = aws_iam_policy.bastion.arn
  subnet_id         = module.network.public_subnets[0]
  environment       = var.name
  name              = var.name
}
