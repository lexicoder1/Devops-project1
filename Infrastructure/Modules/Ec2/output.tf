output "publicip" {
  description = "The ID of the VPC"
  value       = aws_instance.my-ec2.public_ip
}



