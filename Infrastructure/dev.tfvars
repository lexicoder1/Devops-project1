# common variables 
  Env = "Dev"

#  variables for vpc
# when arranging this all public subnet should come first
vpc_cidr = "10.0.0.0/16"
subnet_configurations-public = [{
    name   = "public_subnet1"
    cidr   =  "10.0.2.0/24"
    az     =  "us-west-2a"
    assign-public-ip = true
    public_subnet = true
    
  },{
    name   = "public_subnet2"
    cidr   =  "10.0.10.0/24"
    az     =  "us-west-2b"
    assign-public-ip = true
    public_subnet = true
    
  }]

  subnet_configurations-private = [{
    name   = "private_subnet1"
    cidr   =  "10.0.20.0/24"
    az     =  "us-west-2a"
    assign-public-ip = false
    public_subnet = false
    
  },
  {
    name   = "private_subnet2"
    cidr   =  "10.0.30.0/24"
    az     =  "us-west-2b"
    assign-public-ip = false
    public_subnet = false
    
  }
  ,{
    name   = "private_subnet23"
    cidr   =  "10.0.40.0/24"
    az     =  "us-west-2b"
    assign-public-ip = false
    public_subnet = false
    
  }]
  # this shows the number of public subnet
  my_vpc_name = "myvpc-1"
  gateway_name = "myvpc1_gateway_name"
  route_table_name = "myvpc1_routetable"
  route_table_name_private ="myvpc1_routetable_private"
#   make this false if we dont need nat gateway but for testing sake make false because it creates an elastic ip which cost money so try making it false if we dont need it 
  createnatgateway = false

  # variables for eks 
ekscluster-role-name = "ekscluster-role"
myekscluster-nodegroup-role-name = "myekscluster-nodegroup-role"
cluster-name = "my-cluster1"
node_group_name= "my-nodegroup1"
arn_iamuser_access_to_cluster = "arn:aws:iam::920372995171:user/lexi1"

# variables for jenkins-ec2
jenkins_key_name = "my-key-pair"
jenkins_public_key = "./my-key.pub"
jenkins_ami = "ami-075686beab831bb7f"
jenkins_instance_type= "t2.micro"
jenkins_Ec2_name = "jenkins_ec2"
jenkins_volume_size = 8
# jenkins_subnet_id  = var.jenkins_subnet_id
jenkins_security_group_name = "security_group"
jenkins_inbound_configurations = [{
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  }]

# s3 bucket

# bucket_name =var.bucket_name
# files =var.files
# upload_files = var.upload_files
# enable_bucket_versioning = var.enable_bucket_versioning

# rds mariadb variable 
  rds_subnet_group_name = "rds-subnet-group"
  # note this is same cidr for the vpc that will be used for rds
  rds_vpc_cidr_ipv4  = "10.0.0.0/16"
  rds-mariadb-identifier-name = "my-data-base"
  rds_security_group_name = "my-rds-security-group-3306"
  db_name              = "mydb"
  engine               = "mariadb"
  engine_version       = "11.4.4"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  storage_type = "gp2"
  username             = "admin"
  password             = "foobarbaz"
  publicly_accessible  =  false
  skip_final_snapshot  = true
# dont push dev.tfvars to github instead copy content to dev.tfvars.github and remove sensitive datas like password