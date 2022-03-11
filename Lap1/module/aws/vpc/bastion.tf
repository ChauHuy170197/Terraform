data "aws_ami" "amazon-linux-2" {
    most_recent = true
    owners = ["amazon"]

    filter {
      name = "name"
      values = ["amzn2-ami-hvm*"]
    }
      
}
resource "aws_instance" "brk-bastion" {
    ami = data.aws_ami.amazon-linux-2.id
    associate_public_ip_address = true
    instance_type = "t2.micro"
    key_name = "public"
    subnet_id = aws_subnet.public_subnet[0].id
    vpc_security_group_ids = [aws_security_group.brk-bastion-sg.id]
    tags = {
      "Name" = "brk-bastion"
    }
  
}
resource "aws_key_pair" "public"{
  key_name = "public"
  public_key = file(var.public-key)
}
