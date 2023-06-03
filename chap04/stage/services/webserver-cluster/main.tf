provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-lionel"
    region = "us-east-1"
    key = "stage/services/webserver-cluster/terraform.tfstate"
    encrypt = true
  }
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  
  cluster_name = "webservers-stage"
  db_remote_state_bucket = "terraform-up-and-running-state-lionel"
  db_remote_state_key    = "stage/services/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  min_size = 2
  max_size = 2
}
