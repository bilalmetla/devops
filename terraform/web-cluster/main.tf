provider "aws" {
  region = "us-east-1"
}

resource "aws_launch_configuration" "web-cluster-example" {
  image_id = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.for_web_cluster_ec2_instance.id}"]

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p "${var.server_port}" &
                EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "for_web_cluster" {
  launch_configuration = "${aws_launch_configuration.web-cluster-example.id}"
  availability_zones = ["${data.aws_availability_zones.all.names[0]}"]
  
  load_balancers = ["${aws_elb.web_cluster_elb.name}"]
  health_check_type = "ELB"

  min_size = 2
  max_size = 5
  tag {
    key = "Name"
    value = "web_cluster"
    propagate_at_launch = true
  }
}

resource "aws_elb" "web_cluster_elb" {
  name = "web-cluster-elb"
  availability_zones = ["${data.aws_availability_zones.all.names[0]}"]
  security_groups = ["${aws_security_group.web_cluster_elb.id}"]
  


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
}
