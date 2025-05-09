resource "aws_iam_role" "myeksclusterrole" {
  name = var.ekscluster-role-name
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "eks.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
})
tags = {
   
    Env =  var.Env
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKclusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.myeksclusterrole.name
  depends_on = [
    aws_iam_role.myeksclusterrole
  ]
}

resource "aws_eks_cluster" "my-cluster" {
  name = var.cluster-name

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.myeksclusterrole.arn
  version  = var.cluster-version
  
  

  vpc_config {
    # vpc_id = var.vpc_id
    subnet_ids = var.subnet_ids
    endpoint_public_access = var.endpoint_public_access 
    endpoint_private_access = var.endpoint_private_access
  }
  upgrade_policy {
    support_type = "STANDARD"
  }

  tags = {
   
    Env =  var.Env
  }

  depends_on = [
    aws_iam_role.myeksclusterrole,
    aws_iam_role_policy_attachment.AmazonEKclusterPolicy,
    # aws_eks_node_group.example
  ]
}

locals {
  myaddon = [
{addon_name                  = "kube-proxy "
 addon_version               = "v1.32.0-eksbuild.2"}, 
{addon_name                  = "coredns"
 addon_version               = "v1.11.4-eksbuild.2"}, 
{addon_name                  = "vpc-cni"
 addon_version               = "v1.19.2-eksbuild.1"},
{addon_name                  = "eks-pod-identity-agent"
 addon_version               = "v1.3.4-eksbuild.1"},
{addon_name                  = "metrics-server"
 addon_version               = "v0.7.2-eksbuild.3"}
 ]

}

resource "aws_eks_addon" "my-adson" {
  for_each = { for idx, myaddon in local.myaddon : idx => myaddon }
  cluster_name                = aws_eks_cluster.my-cluster.name
  addon_name                  = each.value.addon_name
  addon_version               = each.value.addon_version 
  resolve_conflicts_on_update = "PRESERVE"
  tags = {
   
    Env =  var.Env
  }
}


resource "aws_iam_role" "my-node-group-role" {
  name = var.myekscluster-nodegroup-role-name
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
})
tags = {
   
    Env =  var.Env
  }
}

locals {

    my-woker-node-policy = ["AmazonEKSWorkerNodePolicy", "AmazonEC2ContainerRegistryReadOnly","AmazonEKS_CNI_Policy"]
}

resource "aws_iam_role_policy_attachment" "eks-node-group-policy" {
  for_each = toset(local.my-woker-node-policy)
  policy_arn = "arn:aws:iam::aws:policy/${each.key}"
  role       = aws_iam_role.my-node-group-role.name
  depends_on = [
    aws_iam_role.my-node-group-role
  ]
}

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.my-cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.my-node-group-role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  ami_type = var.ami_type
  instance_types = [var.instance_types]
  disk_size      = var.disk_size
  capacity_type  = var.capacity_type

 

  update_config {
    max_unavailable = var.max_unavailable
  }

  tags = {
   
    Env =  var.Env
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-node-group-policy,
    aws_iam_role.my-node-group-role
  ]
}



# EKS Access Entry
resource "aws_eks_access_entry" "example_access_entry" {
  cluster_name  = aws_eks_cluster.my-cluster.name
  principal_arn = var.arn_iamuser_access_to_cluster
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "example" {
  cluster_name  = aws_eks_cluster.my-cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.arn_iamuser_access_to_cluster
  access_scope {
    type       = "cluster"
  }
}