provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket       = "terraform-backend-1021-kez"
    key          = "stage/data-store/mysql/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
resource "aws_db_instance" "example" {
  identifier          = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  db_name             = "example_database"

  username = var.db_username
  password = var.db_password
}
