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

output "vpc_id" {
  value = module.network.vpc_id
}

output "private_subnets" {
  value = module.network.private_subnets
}

output "database_subnets" {
  value = module.network.database_subnets
}

output "bastion_public_ip" {
  description = "Bastion public ip"
  value       = length(module.ssm-bastion) > 0 ? module.ssm-bastion[0].client_public_ip : ""
}

/* TODO
output "vpn_gateway_id" {
  value = module.vpn.vpn_gateway_id
}

output "vpn_gateway_public_ip" {
  value = module.vpn.vpn_gateway_public_ip
}

output "vpn_gateway_public_ip_fqdn" {
  value = module.vpn.vpn_gateway_public_ip_fqdn
}
*/
