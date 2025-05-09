# common variables
variable "Env" {
    type = string
  
}

# vpc variables
variable "subnet_configurations-public" {
  type = list(object({
    name   = string
    cidr   = string
    az     = string
    assign-public-ip = bool 
    
  }))

}

variable "subnet_configurations-private" {
  type = list(object({
    name   = string
    cidr   = string
    az     = string
    assign-public-ip = bool 
    
  }))

}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "my_vpc_name" {
  type = string
}

variable "gateway_name" {
  type = string
}

variable "route_table_name" {
  type = string
}
variable "route_table_name_private" {
  type = string
}
variable createnatgateway {
  type = bool 
}


# Eks variables 

variable "ekscluster-role-name" {
    type = string 
}
variable "myekscluster-nodegroup-role-name" {
    type = string
}

variable "cluster-version" {
    type = string
    default = "1.32"
}

variable "cluster-name" {
    type = string 
}

variable "endpoint_public_access" {
    type        = bool
    default     = true 
}

variable "endpoint_private_access" {
    type        = bool
    default     = true
}

variable "node_group_name" {
    type = string 
}

variable "desired_size" {
    type = number
    default =  1
}

variable "max_size" {
    type = number
    default = 1
}

variable "min_size" {
    type = number
    default = 1
}

variable "ami_type" {
    type = string
    default = "AL2_x86_64"
}
variable "instance_types" {
    type = string
    default = "t2.micro"
}
variable "disk_size" {
    type = number
    default = 20
}
variable "capacity_type" {
    type = string
    default = "ON_DEMAND"
}

variable "max_unavailable" {
    type = number
    default = 1
}
variable "arn_iamuser_access_to_cluster" {
    type = string
    default = "arn:aws:iam::920372995171:user/lexi1"
    
}

# my jenkins server variables
variable jenkins_key_name {
    type = string
}
variable  jenkins_public_key {
    type = string
}
variable  jenkins_ami {
    type = string
    default = "ami-075686beab831bb7f"
}
variable  jenkins_instance_type {
    type = string
    default = "t2.micro"
}
variable  jenkins_Ec2_name {
    type = string
}
variable  jenkins_volume_size {
    type = string
}

variable  jenkins_security_group_name {
    type = string
}
variable "jenkins_inbound_configurations" {
  type = list(object({
  cidr_ipv4         = string
  from_port         = number
  to_port           = number
  }))

  default = [{
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  }]
}

# rds mariadb variables
variable rds_subnet_group_name{
  type = string  
}
# variable rds_subnet_ids{
#     type = list(string)
# }
variable rds_security_group_name {
    type = string
}
# variable rds_vpc_id {
#     type =string
# }
variable rds_vpc_cidr_ipv4 {
   type = string
}
variable rds-mariadb-identifier-name{
  type = string
}

variable db_name {
    type =string
}
variable engine{
 type = string
}
variable engine_version{
 type = string
}
variable instance_class{
   type = string
}

variable allocated_storage{
 type = number
}
variable storage_type{
   type = string
}
variable username{
 type =string
}
variable password{
  type = string
}
variable publicly_accessible{
  type =bool
}
variable skip_final_snapshot{
    type =bool
}

# s3 variables 

# variable bucket_name{
#     type = string 
    
# }
# variable files{
#     type = list(object({
#     key    = string
#     source = string
   
#   }))

# }
# variable upload_files{
#     type = bool

# }
# variable enable_bucket_versioning{
#     type = string
#     default = "Enabled"
# }





  
 


