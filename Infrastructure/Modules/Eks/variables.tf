variable "ekscluster-role-name" {
    type = string 
}
variable "myekscluster-nodegroup-role-name" {
    type = string
}
variable "Env" {
    type = string 
}

# variable "vpc_id" {
#     type = string
# }

variable "subnet_ids" {
    type        = list(string)
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
    default = "t3.medium"
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


  
 
