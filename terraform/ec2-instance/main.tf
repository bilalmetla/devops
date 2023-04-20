
provider "aws" {
  region = "us-east-1"
}

variable "server_port" {
  default = 80
  description = "Its port for the http server listening on."
}

resource "aws_instance" "example_instance" {
  # ami = "ami-007855ac798b5175e"
  ami = "ami-0d799247a7590e765"
  instance_type = "t2.micro"
  # user_data = <<-EOF
  #             echo hello, world > index.html
  #             nohup busybox httpd -f -p "${var.server_port}" &
  #             EOF
  tags = {
    Name = "terraform.example"
  }
  vpc_security_group_ids = [ "${aws_security_group.example_instance_security.id}" ]
}

resource "aws_security_group" "example_instance_security" {
  name = "aws_instance.example_instance.security"
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

output "public_ip" {
  value = "${aws_instance.example_instance.public_ip}"
}