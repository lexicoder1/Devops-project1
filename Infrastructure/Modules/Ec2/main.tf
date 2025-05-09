
resource "aws_key_pair" "mykeypair" {
  key_name   = var.key_name
  public_key = file(var.public_key)
  tags = {
    Env = var.Env
  }
}


resource "aws_instance" "my-ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name =aws_key_pair.mykeypair.key_name
  
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.security-group.id]
  root_block_device {
    volume_size = var.volume_size         # Size of the root volume (in GiB)
    volume_type = "gp2"      # Type of the volume (gp2, io1, etc.)
    delete_on_termination = true  # Deletes the root volume when the instance is terminated
  }
  tags = {
    Name = var.Ec2_name
    Env = var.Env
  }
}

resource "aws_security_group" "security-group" {
  name        = var.security_group_name
  vpc_id      = var.vpc_id
  
  tags = {
    Env = var.Env
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule" {
  for_each = { for idx, config in var.inbound_configurations : idx => config }
  security_group_id = aws_security_group.security-group.id
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port 
  ip_protocol       = "tcp"
  to_port           = each.value.to_port
}

resource "aws_vpc_security_group_egress_rule" "eggress_rule" {
  security_group_id = aws_security_group.security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}
