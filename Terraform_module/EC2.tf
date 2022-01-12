module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "test-instance"
  ami                    = "ami-0629230e074c580f2"
  instance_type          = "t2.micro"
  key_name               = "huy-key"
  vpc_security_group_ids = [aws_security_group.test.id]
  subnet_id              = "${aws_subnet.pub_subnet.id}"
  tags = {
     Terraform   = "true"
  }
}