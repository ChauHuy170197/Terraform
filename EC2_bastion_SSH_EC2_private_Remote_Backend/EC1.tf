resource "aws_instance" "EC1" {
  ami           = "ami-0629230e074c580f2"
  instance_type = "t2.micro"
  security_groups      = [aws_security_group.EC1_security.id]
  subnet_id = "${aws_subnet.public_subnet.id}"
  key_name = module.key_pair.key_pair_key_name
  tags = {
     Name = "EC1"
  }
}