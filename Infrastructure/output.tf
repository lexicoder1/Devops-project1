output "public_subnet_ids" {
  description = "List of subnet IDs in the VPC"
  value       =  module.myvpc1.public_subnet_ids
  
}
output "private_subnet_ids" {
  description = "List of subnet IDs in the VPC"
  value       =  module.myvpc1.private_subnet_ids
  
}