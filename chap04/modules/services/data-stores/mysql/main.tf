resource "aws_db_instance" "exampledb" {
  engine = "mysql"
  allocated_storage = var.db_allocated_storage
  instance_class = var.db_instance_class
  db_name = var.database_instance_name
  username = "admin"
  password = "${var.db_password}"
  skip_final_snapshot = "true"
}