
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Provider Block
provider "aws" {
  region = "us-west-1"
}



resource "aws_instance" "provisioner" {

  ami                    = "ami-08012c0a9ee8e21c4"
  instance_type          = "t2.micro"
  key_name               = "ansible-key"
  vpc_security_group_ids = ["sg-09a675e5396be5d5b"]
  subnet_id              = "subnet-09acd2d431e53234e"
  tags = {
    "Name" = "user-data-with-provisioner"
  }
}

resource "aws_eip" "provisioner_eip" {
  instance = aws_instance.provisioner.id
  vpc      = true
  tags = {
    "Name" = "provisioner Pulic IP"
  }
}

resource "null_resource" "copy_ec2_keys" {
  depends_on = [aws_instance.provisioner]
  connection {
    type        = "ssh"
    host        = aws_eip.provisioner_eip.public_ip
    user        = "ubuntu"
    password    = ""
    private_key = file("ansible-key.pem")
  }

  ## File Provisioner: Copies the ansible-key.pem file to /tmp/ansible-key.pem
  provisioner "file" {
    source      = "user_data.sh"
    destination = "/tmp/user_data.sh"
  }
  ## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions 
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/user_data.sh",
      "sudo bash /tmp/user_data.sh"
    ]
  }
}
