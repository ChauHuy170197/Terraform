provider "aws" {
  region = "us-east-2"
}
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "test-instance"
  ami                    = "ami-0629230e074c580f2"
  instance_type          = "t2.micro"
  key_name               = "huy-key"
  vpc_security_group_ids = ["sg-0e814fca5bf765844"]
  subnet_id              = "subnet-03fcfa39150d0db91"
  tags = {
     Terraform   = "true"
  }
}