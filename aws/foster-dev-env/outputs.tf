
output "mtc-dev-node-public-ip" {
    value = aws_instance.fe_dev_node.public_ip
}