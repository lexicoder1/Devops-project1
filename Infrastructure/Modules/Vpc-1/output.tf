output "vpc_id-1" {
  description = "The ID of the VPC"
  value       = aws_vpc.my-vpc.id
}



output "public_subnet_ids" {
  description = "List of subnet IDs in the VPC"
 
  value       =   [for s in aws_subnet.my-public-subnet : s.id]
  
}

output "private_subnet_ids" {
  
  description = "List of subnet IDs in the VPC"
  value              =  [for s in aws_subnet.my-private-subnet : s.id]
  
}


