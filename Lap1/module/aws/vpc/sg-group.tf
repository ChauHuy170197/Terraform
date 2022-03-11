resource "aws_security_group" "brk-bastion-sg"{
    vpc_id      = aws_vpc.vpc.id
    name    = "public"
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
    
    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "brk-web-sg"{
    vpc_id      = aws_vpc.vpc.id
    name    = "private"
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["10.20.0.0/24"]
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
    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}

# Security-ALB
resource "aws_lb_target_group" "lb_sg" {
  health_check{
    interval = 10
    path = "/" 
    protocol = "HTTP"
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }

  name = "lb-sg"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = aws_vpc.vpc.id 
  
}

resource "aws_lb_target_group_attachment" "alb" {
  target_group_arn = aws_lb_target_group.lb_sg.arn
  target_id = aws_instance.webserver.id
  port = 80
  
}
resource "aws_security_group" "lb_sg" {
    vpc_id = aws_vpc.vpc.id
    name = "lb_sg"
    description = "security for lb"
    
}
resource "aws_security_group_rule" "inbound_ssh" {
  from_port = 22
  protocol = "TCP"
  security_group_id = aws_security_group.lb_sg.id
  to_port = 22
  type =  "ingress"
  cidr_blocks = ["0.0.0.0/0"]
 
}
resource "aws_security_group_rule" "inbound_http" {
  from_port = 80
  protocol = "TCP"
  security_group_id = aws_security_group.lb_sg.id
  to_port = 80
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  
}
resource "aws_security_group_rule" "outbound_all" {
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.lb_sg.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  
}

resource "aws_lb" "app-lb" {
  name = "app-lb"
  internal = false
  security_groups = [aws_security_group.lb_sg.id]
  subnets = [aws_subnet.public_subnet[0].id,aws_subnet.public_subnet[1].id]
  tags = {
    "Name" = "app-lb"

  }
}
resource "aws_lb_listener" "lb-listner" {
  load_balancer_arn = aws_lb.app-lb.arn
  port = 80
  protocol = "HTTP"
  
  default_action {
    target_group_arn = aws_lb_target_group.lb_sg.id
    type = "forward"
  }
  tags = {
    Name = "lb-listner"
  }
}
