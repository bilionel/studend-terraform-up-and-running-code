data "aws_availability_zones" "all" {
  
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "${var.db_remote_state_bucket}"
    key = "${var.db_remote_state_key}"
    region = "us-east-1"
  }
}


resource "aws_launch_configuration" "example" {
  image_id           = "ami-40d28157"
  instance_type = "${var.instance_type}"

  user_data = templatefile("${path.module}/user-data.sh", { db_port = "${data.terraform_remote_state.db.outputs.port}", db_address = "${data.terraform_remote_state.db.outputs.address}", server_port = "${var.server_port}"})
  
  security_groups = [ "${aws_security_group.instance.id}" ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_http_inbound_instance" {
  type              = "ingress"
  security_group_id = "${aws_security_group.instance.id}"

  from_port   = "${var.server_port}"
  to_port     = "${var.server_port}"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_inbound_elb" {
  type              = "ingress"
  security_group_id = "${aws_security_group.elb.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.elb.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "elb" {
  name = "${var.cluster_name}-elb"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  name = "${var.cluster_name}-${aws_launch_configuration.example.name}"
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones = data.aws_availability_zones.all.names

  load_balancers = ["${aws_elb.example.name}"]
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size
  min_elb_capacity = var.min_size

  tag {
    key = "Name"
    value = "${var.cluster_name}-example"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_elb" "example" {
  name = "${var.cluster_name}-example"
  availability_zones = data.aws_availability_zones.all.names
  security_groups = [ "${aws_security_group.elb.id}" ]

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.server_port}/"
  }

  lifecycle {
    create_before_destroy = true
  }
}
