remote_state = {
    backend = "s3"

    config = {
        encrypt = true
        bucket = "terraform-up-and-running-state-lionel"
        key = "global/s3/terraform.tfstate"
        region =  "us-east-1"
        dynamodb_table = "my-lock-table"
    }
}