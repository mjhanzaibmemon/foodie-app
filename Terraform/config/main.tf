################################################################################
#                               VPC                                            #
################################################################################

module "vpc" {
  source     = "../modules/vpc"
  cidr_block = "10.0.0.0/16"
  tags_name  = "vpc"
}

################################################################################
#                         EKS Cluster Subnets                                  #
################################################################################

module "eks_subnet_1" {
  source                  = "../modules/subnet"
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"

  depends_on = [module.vpc]
}

module "eks_subnet_2" {
  source                  = "../modules/subnet"
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2b"

  depends_on = [module.vpc]
}

################################################################################
#                           IAM ROLES                                          #
################################################################################

module "eks_cluster_iam_role" {
  source    = "../modules/iam"
  role_name = "eks_cluster_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# EKS Node Group Role
module "eks_node_group_role" {
  source    = "../modules/iam"
  role_name = "eks_node_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

################################################################################
#                   EKS Cluster Role Policy Attachments                        #
################################################################################

module "eks_cluster_policy_attachment" {
  source                      = "../modules/iam_role_policy_attachment"
  policy_attachment_role_name = module.eks_cluster_iam_role.role_name
  cluster_policy_arn          = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  depends_on = [module.eks_cluster_iam_role]
}

# Attach AmazonEKSServicePolicy to cluster role
module "eks_service_policy_attachment" {
  source                      = "../modules/iam_role_policy_attachment"
  policy_attachment_role_name = module.eks_cluster_iam_role.role_name
  cluster_policy_arn          = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"

  depends_on = [module.eks_cluster_iam_role]
}

################################################################################
#                   Node Group Policy Attachments                              #
################################################################################

module "eks_worker_node_policy_attachment" {
  source                      = "../modules/iam_role_policy_attachment"
  policy_attachment_role_name = module.eks_node_group_role.role_name
  cluster_policy_arn          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  depends_on = [module.eks_node_group_role]
}

# CNI Policy
module "eks_node_cni_policy_attachment" {
  source                      = "../modules/iam_role_policy_attachment"
  policy_attachment_role_name = module.eks_node_group_role.role_name
  cluster_policy_arn          = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

  depends_on = [module.eks_node_group_role]
}

# ECR ReadOnly Policy
module "eks_node_ecr_policy_attachment" {
  source                      = "../modules/iam_role_policy_attachment"
  policy_attachment_role_name = module.eks_node_group_role.role_name
  cluster_policy_arn          = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

  depends_on = [module.eks_node_group_role]
}

################################################################################
#                               EKS Cluster                                    #
################################################################################

module "eks_cluster" {
  source                    = "../modules/eks_cluster"
  cluster_name              = "my-eks-cluster"
  kubernetes_version        = "1.32"
  role_arn                  = module.eks_cluster_iam_role.role_arn
  authentication_mode       = "API"
  subnet_ids                = [module.eks_subnet_1.subnet_id, module.eks_subnet_2.subnet_id]
  enabled_cluster_log_types = ["api", "audit", "authenticator"]
  service_ipv4_cidr         = "172.20.0.0/16"

  endpoint_private_access = true
  endpoint_public_access  = true
  public_access_cidrs     = ["0.0.0.0/0"]

  tags = {
    Project = "eks-setup"
  }

  depends_on = [
    module.vpc,
    module.eks_cluster_iam_role,
    module.eks_cluster_policy_attachment,
    module.eks_service_policy_attachment
  ]
}

################################################################################
#                               EKS Node Group                                 #
################################################################################

module "eks_node_group" {
  source = "../modules/eks_node_group"

  cluster_name    = module.eks_cluster.cluster_name
  node_group_name = "eks_node_group_default"
  node_role_arn   = module.eks_node_group_role.role_arn

  subnet_ids = [
    module.eks_subnet_1.subnet_id,
    module.eks_subnet_2.subnet_id
  ]

  ami_type       = "AL2023_x86_64_STANDARD"
  instance_types = ["t2.micro"]

  desired_size = 1
  max_size     = 3
  min_size     = 1


  depends_on = [
    module.eks_node_group_role,
    module.eks_cluster,
    module.eks_worker_node_policy_attachment,
    module.eks_node_cni_policy_attachment,
    module.eks_node_ecr_policy_attachment,
  ]
}

################################################################################
#                               ECR Repository                                 #
################################################################################

module "ecr" {
  source               = "../modules/ecr"
  ecr_repository_name  = "my-ecr-repo"
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true

  depends_on = [
    module.eks_node_ecr_policy_attachment
  ]
}

################################################################################
#                               Internet Gateway                               #
################################################################################

module "internet_gateway" {

  source = "../modules/igw"

  vpc_id = module.vpc.vpc_id

  depends_on = [module.vpc]
}

################################################################################
#                                  RouteTable                                  #
################################################################################

module "route_table" {

  source = "../modules/route_table"

  vpc_id  = module.vpc.vpc_id
  rt_name = "Internet_route"

  depends_on = [module.eks_subnet_1, module.eks_subnet_2]
}

################################################################################
#                                    Route                                    #
################################################################################

module "routes" {

  source = "../modules/route"

  route_table_id         = module.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.internet_gateway.igw_id

  depends_on = [module.route_table]
}

################################################################################
#                           Route Table Association                            #
################################################################################

module "subnet_1_rt_association" {

  source = "../modules/route_table_association"

  subnet_id      = module.eks_subnet_1.subnet_id
  route_table_id = module.route_table.id

  depends_on = [module.route_table]

}

module "subnet_2_rt_association" {

  source = "../modules/route_table_association"

  subnet_id      = module.eks_subnet_2.subnet_id
  route_table_id = module.route_table.id

  depends_on = [module.route_table]

}
