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

variable "Env" {
    type = string
  
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