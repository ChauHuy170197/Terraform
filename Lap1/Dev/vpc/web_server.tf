module "ec2_instance" {
  source  = "../../module/aws/vpc"
  name = local.conf.webserver.instance_name
  key_name = local.conf.webserver.key_name
  tags = {
     Terraform   = "true"
  }
}
