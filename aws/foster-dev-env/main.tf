# Create a VPC
# resource "aws_vpc" "fe_vpc" {
#   cidr_block           = "10.123.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true

#   tags = {
#     "Name" = "fe-dev"
#   }
# }

# resource "aws_subnet" "fe_public_subnet" {
#   vpc_id     = aws_vpc.fe_vpc.id
#   cidr_block = "10.123.1.0/24"
#   #   availability_zone = "us-east-1"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "fe-dev-public"
#   }
# }

# resource "aws_internet_gateway" "fe_igw" {
#   vpc_id = aws_vpc.fe_vpc.id

#   tags = {
#     Name = "fe-dev-ig"
#   }
# }

# resource "aws_route_table" "fe_public_rt" {
#   vpc_id = aws_vpc.fe_vpc.id

#   tags = {
#     Name = "fe-dev-rt"
#   }
# }

# resource "aws_route" "fe_default_rout" {
#   route_table_id         = aws_route_table.fe_public_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.fe_igw.id
# }

# resource "aws_route_table_association" "fe_public_assoc" {
#   subnet_id      = aws_subnet.fe_public_subnet.id
#   route_table_id = aws_route_table.fe_public_rt.id
# }

# resource "aws_default_vpc" "default" {
#   tags = {
#     Name = "Default VPC"
#   }
# }

# resource "aws_subnet" "fe_public_subnet" {
#   vpc_id     = aws_vpc.fe_vpc.id
# }

resource "aws_security_group" "fe_dev_sg" {
  name        = "fe-dev"
  description = "fe dev security group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port       = 0
    to_port        = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress  {
    from_port       = 0
    to_port         = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_key_pair" "fe_auth" {
  key_name = var.instanceAuth 
  public_key = file(var.authFile) 
}

resource "aws_instance" "fe_dev_node" {
  instance_type = "t2.micro"
  ami = data.aws_ami.ubuntu.id
  key_name = aws_key_pair.fe_auth.id #key_name
  vpc_security_group_ids = [ aws_security_group.fe_dev_sg.id ]
  # subnet_id =  data.aws_subnet.public.id #aws_subnet.fe_public_subnet.id 

  user_data = file("userdata.tpl")

  tags = {
    "Name" = "fe-dev-node"
  }

  root_block_device {
    volume_size = 30
  }

   provisioner "file" {
    source      = "C:/Users/m.bilal/Documents/code/dev-foster"
    destination = "/home/ubuntu/"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.authFilePrivate) 
      host        = "${self.public_dns}"
    }
  }

}