resource "aws_instance" "hello" {
  ami           = "ami-0629230e074c580f2"
  instance_type = "t2.micro"
  security_groups      = [aws_security_group.EC2_security.id]
  subnet_id = "${aws_subnet.private_subnet.id}"
  tags = {
     Name = "EC2"
  }
}