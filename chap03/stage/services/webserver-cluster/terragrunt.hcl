remote_state = {
    backend = "s3"

    config = {
        encrypt = true
        bucket = "terraform-up-and-running-state-lionel"
        key = "stage/services/webserver-cluster/terraform.tfstate"
        region =  "us-east-1"
        dynamodb_table = "my-lock-table-webserver"
    }
}