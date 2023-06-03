remote_state = {
    backend = "s3"

    config = {
        encrypt = true
        bucket = "terraform-up-and-running-state-lionel"
        key = "prod/services/data-stores/mysql/terraform.tfstate"
        region =  "us-east-1"
        dynamodb_table = "my-lock-table-mysql"
    }
}