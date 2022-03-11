resource "aws_instance" "webserver" {
    ami = data.aws_ami.amazon-linux-2.id
    associate_public_ip_address = true
    instance_type = "t2.micro"
    key_name = "public"
    subnet_id = aws_subnet.private_subnets[0].id
    vpc_security_group_ids = [aws_security_group.brk-web-sg.id]
    tags = {
      "Name" = "webserver"
    }
       
}
