locals {
  common-config = yamldecode(file("../../common-config.yaml"))
  vpc           = yamldecode(file("../vpc.yaml"))
  conf          = yamldecode(file("../config.yaml"))
}

data "aws_availability_zones" "available" {
}

module "vpc" {
  source  = "../../module/aws/vpc"
  namespace = local.conf.namespace

  vpc_cidr_block = local.vpc.vpc_cidr
  vpc_name       = local.vpc.vpc_name
  igw_name = local.vpc.igw_name

  single_nat_gateway = local.vpc.single_nat_gateway
  eip_name           = local.vpc.eip_name
  natgw_name         = local.vpc.natgw_name

  azs                      = data.aws_availability_zones.available.names
  public_subnets           = local.vpc.public_subnets
  public_subnets_name      = local.vpc.public_subnets_name
  private_subnets          = local.vpc.private_subnets
  private_subnets_name     = local.vpc.private_subnets_name
  db_subnets               = local.vpc.db_subnets
  db_subnets_name          = local.vpc.db_subnets_name

  rtb_public_name  = local.vpc.rtb_public_name
  rtb_private_name = local.vpc.rtb_private_name
}


