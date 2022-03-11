module "ec2_instance" {
  source  = "../../module/aws/vpc"
  name = local.conf.bastinon.instance_name
  key_name = local.conf.bastinon.key_name
  tags = {
     Terraform   = "true"
  }
}
