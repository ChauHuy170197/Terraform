provider "aws" {
  region = "us-east-2"
}
resource "aws_vpc" "vpc_test" {
    cidr_block = "10.20.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags       = {
        Name = "VPC"
    }
}
resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc_test.id
}
resource "aws_subnet" "public_subnet" {
    vpc_id                  = aws_vpc.vpc_test.id
    cidr_block              = "10.20.1.0/24"
}
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc_test.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }
}

resource "aws_route_table_association" "route_table_association" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public.id
}
resource "aws_subnet" "private_subnet" {
    vpc_id                  = aws_vpc.vpc_test.id
    cidr_block              = "10.20.2.0/24"
}
resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  key_name   = "test-key"
  public_key = tls_private_key.this.public_key_openssh
}