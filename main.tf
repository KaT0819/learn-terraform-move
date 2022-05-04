terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 1.1.0"
}


data "aws_availability_zones" "available" {
  state = "available"
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "learn_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

module "ec2_instance" {
  source = "./modules/compute"
  # モジュール内の変数に値を設定。左辺はモジュールの変数、右辺は上記vpcモジュールの値
  security_group = module.security_group.sg_id
  public_subnets = module.learn_vpc.public_subnets
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.learn_vpc.vpc_id
}

moved {
  from = aws_instance.example
  to   = module.ec2_instance.aws_instance.example
}

moved {
  from = aws_security_group.sg_8080
  to   = module.security_group.aws_security_group.sg_8080
}

moved {
  from = module.vpc
  to   = module.learn_vpc
}
