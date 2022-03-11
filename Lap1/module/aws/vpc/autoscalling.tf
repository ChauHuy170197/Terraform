resource "aws_launch_configuration" "ec2_config" {
  name = "ec2_config"
  image_id = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"

}

resource "aws_autoscaling_group" "autoscaling" {
  name = "autoscaling"
  vpc_zone_identifier = [aws_subnet.private_subnet[0].id,aws_subnet.private_subnet[1].id]
  launch_configuration = aws_launch_configuration.ec2_config.name
  min_size = 1
  max_size = 3
  health_check_grace_period = 100
  health_check_type = "EC2"
  force_delete = true
  tag{
    key = "Name"
    value = "autoscaling"
    propagate_at_launch = true
  }
}