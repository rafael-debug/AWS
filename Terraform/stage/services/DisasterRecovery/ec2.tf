resource "aws_key_pair" "key" {
  key_name = "aws-key-gophish"
  #public_key = file(var.aws_pub_key)
  public_key = file("./aws-key-gophish.pub")

}


resource "aws_instance" "ec2" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_type
  key_name                    = aws_key_pair.key.key_name
  subnet_id                   = aws_subnet.subnet1.id
  vpc_security_group_ids      = [aws_security_group.sg-WebServerSG.id]
  associate_public_ip_address = true


  user_data = <<EOF
#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
sudo curl -s -o /var/www/html/index.html https://raw.githubusercontent.com/ChandraLingam/disaster-recovery/main/WebPage/index.html
echo "done"
  EOF

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public_ip.txt"
  }

  provisioner "file" {
    content     = "ami used: ${self.public_ip}"
    destination = "/tmp/public_ip.txt"
  }

  provisioner "file" {
    source      = "~/terraform_project/teste.txt"
    destination = "/tmp/testee.txt"
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
 

}

