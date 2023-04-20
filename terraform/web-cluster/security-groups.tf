

resource "aws_security_group" "for_web_cluster_ec2_instance" {
    name = "security group for web cluster ec2 instance"

    ingress {
        from_port = "${var.server_port}"
        to_port = "${var.server_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group" "web_cluster_elb" {
  name = "for_elb"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
 }

}
