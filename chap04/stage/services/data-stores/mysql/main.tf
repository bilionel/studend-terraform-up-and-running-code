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

module "database_module" {
  source = "../../../../modules/services/data-stores/mysql"

  database_instance_name = "stage_db"
  db_instance_class = "db.t2.micro"
  db_allocated_storage = 20
  db_password = var.db_password
}
