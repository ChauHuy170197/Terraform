provider "aws" {
  region = "us-east-2"
}
resource "aws_vpc" "vpc" {
    cidr_block = "10.10.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags       = {
        Name = "Terraform VPC"
    }
}
resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id
}
resource "aws_subnet" "pub_subnet" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.10.4.0/24"
}
resource "aws_subnet" "rds_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.5.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "rds_subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.6.0/24"
  availability_zone = "us-east-2b"
}
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }
}
resource "aws_route_table_association" "route_table_association" {
    subnet_id      = aws_subnet.pub_subnet.id
    route_table_id = aws_route_table.public.id
}
resource "aws_security_group" "test"{
    vpc_id      = aws_vpc.vpc.id
    name    = "alow_ssh"
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
   }

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "rds_sg" {
    vpc_id      = aws_vpc.vpc.id
    
    ingress {
        protocol        = "tcp"
        from_port       = 3306
        to_port         = 3306
        cidr_blocks     = ["0.0.0.0/0"]
        security_groups = [aws_security_group.test.id]
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}
resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  key_name   = "huy-key"
  public_key = tls_private_key.this.public_key_openssh
}
