variable key_name {
    type = string
}
variable  public_key {
    type = string
}
variable  ami {
    type = string
    default = "ami-075686beab831bb7f"
}
variable  instance_type {
    type = string
    default = "t2.micro"
}
variable  Ec2_name {
    type = string
}
variable  volume_size {
    type = string
}
variable  subnet_id  {
    type = string
}
variable  Env  {
    type = string
}
variable  vpc_id {
    type = string
}
variable  security_group_name {
    type = string
}
variable "inbound_configurations" {
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
