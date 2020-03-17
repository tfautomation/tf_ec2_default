provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "defaultvpc" {

}

data "aws_subnet_ids" "subnetids" {
  vpc_id = aws_default_vpc.defaultvpc.id
}

resource "aws_security_group" "httpserver_secgrp_local" {

  name   = "httpserver_secgrp"
  vpc_id = aws_default_vpc.defaultvpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "httpserverlocal" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = tolist(data.aws_subnet_ids.subnetids.ids)[0]
  vpc_security_group_ids      = [aws_security_group.httpserver_secgrp_local.id]
  key_name                    = "default-ec2-key"
  associate_public_ip_address = true
  tags = {
    name = "httpserver"
  }

  connection {
      type="ssh"
      host=self.public_ip
      user="ec2-user"
      private_key=file("~/.aws/keys/default-ec2-key.pem")
  }

  provisioner "remote-exec" {
      inline = [
          "sudo yum install -y httpd",
          "sudo service httpd start",
          "echo vijay enjoys terraform magics | sudo tee /var/www/html/index.html"
          ]
  }
}

