resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.rds_subnet_group_name
  subnet_ids = var.rds_subnet_ids

  tags = {
    Name = var.rds_subnet_group_name
    Env = var.Env
  }
}

resource "aws_db_instance" "mydb" {
  db_name              = var.db_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  identifier           = var.rds-mariadb-identifier-name
  storage_type = var.storage_type
  username             = var.username
  password             = var.password
  publicly_accessible  =  var.publicly_accessible
  skip_final_snapshot  = var.skip_final_snapshot
  vpc_security_group_ids = [aws_security_group.rds-security-group.id]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  tags = {
    Env = var.Env
    
  }
}
resource "aws_security_group" "rds-security-group" {
  name        = var.rds_security_group_name
  vpc_id      = var.rds_vpc_id
  
  tags = {
    Env = var.Env
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule" {
  
  security_group_id = aws_security_group.rds-security-group.id
  cidr_ipv4         =var.rds_vpc_cidr_ipv4
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

resource "aws_vpc_security_group_egress_rule" "eggress_rule" {
  security_group_id = aws_security_group.rds-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}