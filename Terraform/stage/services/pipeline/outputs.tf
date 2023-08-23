output "remote_subnet" {
  value = aws_subnet.subnet.id
}

output "remote_security_group" {
  value = aws_security_group.sg.id
}

output "vm_ip" {
  value = aws_instance.ec2.public_ip
}