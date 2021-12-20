provider "aws" {
  region = "ap-southeast-1"
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
    cidr_block              = "10.10.0.0/22"
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

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}
resource "aws_instance" "hello" {
  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = "t2.micro"
  security_groups      = ["${aws_security_group.test.id}"]
  subnet_id = "${aws_subnet.pub_subnet.id}"
  tags = {
     Name = "hello"
  }
}
output "ec2" {
  value = {
    public_ip = aws_instance.hello.public_ip
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