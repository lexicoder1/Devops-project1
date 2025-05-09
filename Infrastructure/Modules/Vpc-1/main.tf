# step1 : create vpc 
resource "aws_vpc" "my-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.my_vpc_name
    Env = var.Env
  }
}

# subnet_configurations = [{
#     name   = "public_subnet1"
#     cidr   =  "10.0.2.0/24"
#     az     =  "us-west-2a"
    
#   },{
#     name   = "public_subnet2"
#     cidr   =  "10.0.10.0/24"
#     az     =  "us-west-2a"
    
#   },{
#     name   = "private_subnet1"
#     cidr   =  "10.0.20.0/24"
#     az     =  "us-west-2a"
    
#   }]
# The for_each = { for idx, subnet in var.subnet_configurations : idx => subnet } converts a list "subnet_configurations" into a map so that 
# each.key gives us index and each.value gives the object { name   = "public_subnet1" cidr   =  "10.0.2.0/24" az     =  "us-west-2a"}, 
# if we convert the list to toset we cant get the index

resource "aws_subnet" "my-public-subnet" {
# 
  for_each = { for idx, subnet in var.subnet_configurations-public : idx => subnet }
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  depends_on = [
    aws_vpc.my-vpc
  ]
  map_public_ip_on_launch = each.value.assign-public-ip

  tags = {
    Name = each.value.name
    Env =  var.Env
  }
}
resource "aws_subnet" "my-private-subnet" {
# 
  for_each = { for idx, subnet in var.subnet_configurations-private : idx => subnet }
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  depends_on = [
    aws_vpc.my-vpc
  ]
  map_public_ip_on_launch = each.value.assign-public-ip

  tags = {
    Name = each.value.name
    Env =  var.Env
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.my-vpc.id


  tags = {
    Name = var.gateway_name
    Env =  var.Env
  }
}


resource "aws_route_table" "my-public-routetable" {

  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = var.route_table_name
    Env = var.Env
  }
}


resource "aws_route_table_association" "a-public" {
  for_each = { for idx, subnet in var.subnet_configurations-public : idx => subnet}
  
 
  subnet_id      = aws_subnet.my-public-subnet[each.key].id 
  route_table_id = aws_route_table.my-public-routetable.id
}

resource "aws_route_table" "my-private-routetable" {
  # if var.createnatgateway equal false   then count is 0 then it terraform wont create resource my-private-routetable 
  count = var.createnatgateway ? 1 : 0
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # [0] here because of the count in nat-gateway resource due to the conditional provisioning of resource if createnatgateway = true
    nat_gateway_id = aws_nat_gateway.mynat-gateway[0].id
  }

  tags = {
    Name = var.route_table_name_private
    Env = var.Env
  }
}


resource "aws_route_table_association" "a-private" {
 # if var.createnatgateway equal false then for_each = {} then  terraform wont create this resource
  for_each =  var.createnatgateway ? { for idx, subnet in var.subnet_configurations-private : idx => subnet  } : {}
 
  subnet_id      = aws_subnet.my-private-subnet[each.key].id 
  # [0] here because of the count in my-private-routetable resource due to the conditional provisioning of resource if createnatgateway = true
  route_table_id = aws_route_table.my-private-routetable[0].id
 
}



resource "aws_nat_gateway" "mynat-gateway" {
  # if var.createnatgateway equal false  then count is 0 then it terraform wont create nat gateway
  count = var.createnatgateway ? 1 : 0 
  # [0] here because of the count in nat_gateway_eip resource due to the conditional provisioning of resource if createnatgateway = true
  allocation_id = aws_eip.nat_gateway_eip[0].id
  subnet_id     = aws_subnet.my-public-subnet[0].id

  tags = {
    Name = "my-Nat-gateway"
    Env = var.Env
  }

  depends_on = [aws_internet_gateway.gateway]
}

resource "aws_eip" "nat_gateway_eip" {
  # if var.createnatgateway equal false  then count is 0 then it terraform wont create elastic ip  case no need be we only need for nat gateway
  count = var.createnatgateway ? 1 : 0
  tags = {
    Name = ""
    Env = var.Env
  }
}
