locals {
  name = "complete-mysql"
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

module "terraform-aws-rds-source" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-rds.git?ref=v3.0.0"

  identifier = "mysql-source"

  engine         = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"

  allocated_storage     = 50
  max_allocated_storage = 100

  name     = "mydb_source"
  username = "foos"
  password = "foobarbaz"
  port     = 3306

  parameter_group_name      = "default.mysql5.7"
  create_db_parameter_group = false
  create_db_option_group    = false

  maintenance_window = "Sun:05:00-Sun:06:00"
  backup_window      = "09:46-10:16"

  backup_retention_period = 10
  skip_final_snapshot     = true

  subnet_ids             = ["subnet-bcd186b2", "subnet-d7cc6ce6"]
  vpc_security_group_ids = ["sg-476ef04a"]
}

module "terraform-aws-rds-read" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-rds.git?ref=v3.0.0"

  identifier = "mysql-read"

  engine         = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"

  allocated_storage     = 50
  max_allocated_storage = 100

  # Username and password should not be set for replicas
  name     = "mydb_read"
  username = null
  password = null
  port     = 3306

  parameter_group_name      = "default.mysql5.7"
  create_db_parameter_group = false
  create_db_option_group    = false

  maintenance_window = "Sun:05:00-Sun:06:00"
  backup_window      = "09:46-10:16"

  #for read replica
  replicate_source_db = module.terraform-aws-rds-source.db_instance_id

  backup_retention_period = 10
  skip_final_snapshot     = true

  create_db_subnet_group = false
}
