resource "aws_subnet" "rds_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.5.0/24"
  availability_zone = "us-east-2a"
}
resource "aws_subnet" "rds_subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.6.0/24"
  availability_zone = "us-east-2b"
}
resource "aws_security_group" "rds_sg" {
    vpc_id      = aws_vpc.vpc.id
    name    = "alow_sql"
    ingress {
        protocol        = "tcp"
        from_port       = 3306
        to_port         = 3306
        cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}
resource "aws_db_subnet_group" "db_subnet_group" {
    name       = "database_subnet"
    subnet_ids = [aws_subnet.rds_subnet.id, aws_subnet.rds_subnet1.id]
}
resource "aws_db_instance" "mysql" {
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
    db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.id
    vpc_security_group_ids    = [aws_security_group.rds_sg.id]
    skip_final_snapshot       = true
    final_snapshot_identifier = "huy-final"
    publicly_accessible       = true
}

