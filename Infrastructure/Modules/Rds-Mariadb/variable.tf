variable rds_subnet_group_name{
  type = string  
}
variable rds_subnet_ids{
    type = list(string)
}
variable rds_security_group_name {
    type = string
}
variable rds-mariadb-identifier-name{
  type = string
}
variable rds_vpc_id {
    type =string
}
variable rds_vpc_cidr_ipv4 {
   type = string
}
variable Env {
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
 