provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-lionel"
    region = "us-east-1"
    key = "stage/services/data-stores/mysql/terraform.tfstate"
    encrypt = true
  }
}

resource "aws_db_instance" "exampledb" {
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  db_name = "example_database"
  username = "admin"
  password = "${var.db_password}"
}