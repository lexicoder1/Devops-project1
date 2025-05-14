module "myvpc1" {
  source = "./Modules/Vpc-1"
  vpc_cidr = var.vpc_cidr
  subnet_configurations-public = var.subnet_configurations-public
  subnet_configurations-private = var.subnet_configurations-private
  Env = var.Env
  my_vpc_name = var.my_vpc_name
  gateway_name = var.gateway_name
  route_table_name = var.route_table_name  
  route_table_name_private =var.route_table_name_private
  createnatgateway = var.createnatgateway      
}

module "my-cluster1" {
source = "./Modules/Eks"
ekscluster-role-name = var.ekscluster-role-name
myekscluster-nodegroup-role-name = var.myekscluster-nodegroup-role-name
Env = var.Env
subnet_ids = module.myvpc1.private_subnet_ids
cluster-name = var.cluster-name
node_group_name= var.node_group_name
arn_iamuser_access_to_cluster = var.arn_iamuser_access_to_cluster  
}


module "my-jenkins-Ec2" {
source = "./Modules/Ec2"
key_name = var.jenkins_key_name
public_key = var.jenkins_public_key
ami = var.jenkins_ami
instance_type= var.jenkins_instance_type
Ec2_name = var.jenkins_Ec2_name
volume_size = var.jenkins_volume_size
subnet_id  = module.myvpc1.public_subnet_ids[0]
Env  = var.Env
vpc_id = module.myvpc1.vpc_id-1
security_group_name = var.jenkins_security_group_name
inbound_configurations = var.jenkins_inbound_configurations
}

output "publicip" {
  value = module.my-jenkins-Ec2.publicip
}



module "my-rds" {
source = "./Modules/Rds-Mariadb" 
rds_subnet_group_name = var.rds_subnet_group_name
rds-mariadb-identifier-name = var.rds-mariadb-identifier-name
rds_subnet_ids = module.myvpc1.private_subnet_ids
rds_security_group_name = var.rds_security_group_name
rds_vpc_id =module.myvpc1.vpc_id-1
rds_vpc_cidr_ipv4 = var.rds_vpc_cidr_ipv4
Env = var.Env
db_name =var.db_name
engine=var.engine
engine_version = var.engine_version
instance_class =var.instance_class
allocated_storage = var.allocated_storage
storage_type = var.storage_type
username = var.username
password = var.password
publicly_accessible = var.publicly_accessible
skip_final_snapshot = var.skip_final_snapshot 
}
output "rds_endpoints" {
  description = "List of subnet IDs in the VPC"
  value       =  module.my-rds.rds_endpoint
  
}



