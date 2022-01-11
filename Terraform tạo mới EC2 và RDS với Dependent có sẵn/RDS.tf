provider "aws" {
  region = "us-east-2"
}
module "db" {
    source  = "terraform-aws-modules/rds/aws"
    identifier                = "mysql"
    allocated_storage         = 5
    backup_retention_period   = 2
    backup_window             = "01:00-01:30"
    maintenance_window        = "sun:03:00-sun:03:30"
    engine                    = "mysql"
    engine_version            = "5.7"
    instance_class            = "db.t2.micro"
    name                      = "huy_db"
    username                  = "huy"
    password                  = "Huy1701972021"
    port                      = "3306"
  vpc_security_group_ids = ["sg-03e0c95e9bd528b4c"]
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
  # DB subnet group
  subnet_ids = ["subnet-0404657a0820f9d7b", "subnet-0ee7052f456797db6"]
  # DB parameter group
  family = "mysql5.7"
  # DB option group
  major_engine_version = "5.7"
  # Database Deletion Protection
  deletion_protection = true
  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}