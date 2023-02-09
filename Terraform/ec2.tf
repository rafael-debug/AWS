resource "aws_key_pair" "key" {
  key_name   = "aws-key-gophish"
  public_key = var.aws_pub_key
  #public_key = file("~/terraform_project/aws-key-gophish.pub")

}


resource "aws_instance" "ec2" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_type
  key_name                    = aws_key_pair.key.key_name
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public_ip.txt"
  }

  provisioner "file" {
    content     = "ami used: ${self.public_ip}"
    destination = "/tmp/public_ip.txt"
  }

  provisioner "file" {
    source      = "~/terraform_project/teste.txt"
    destination = "tmp/testee.txt"
  }


  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/terraform_project/aws-key-gophish")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo ami: ${self.ami} >> /tmp/ami.txt",
      "echo private_ip: ${self.private_ip} >> /tmp/private_ip.txt",
      "echo public_ip: ${self.public_ip} >> /tmp/public_ip.txt"
    ]
  }

  tags = var.ec2_tag
}


