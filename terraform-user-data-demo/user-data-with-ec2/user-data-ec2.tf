
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


resource "aws_instance" "user_data_with_ec2" {
  ami           = "ami-08012c0a9ee8e21c4"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0ee434944209b0c76"
  key_name      = "ansible-key"
  vpc_security_group_ids = ["sg-09a675e5396be5d5b"]
  associate_public_ip_address = true

  tags = {
    Name = "user_data_with_ec2"
  }
  #user_data              = file("${path.module}/user_data.sh")
  # User data script to install Apache2
  user_data = <<-EOF
#!/bin/bash
sudo apt update
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
echo '<!DOCTYPE html>
<html>
<head>
    <title>techwithso4</title>
</head>
<body>
    <h1>Hello, welcome to techwithso4!</h1>
    <p>This is a simple "Hello, World!" webpage hosted on server with IP '"$(hostname -i)"'</p>
</body>
</html>' | sudo tee /var/www/html/index.html
EOF

}

