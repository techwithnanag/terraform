
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

#create a launch template for user data
#######case 1 using network interfaces###########
resource "aws_launch_template" "user_data_template" {
  name_prefix   = "user-data-template"
  image_id      = "ami-08012c0a9ee8e21c4"
  instance_type = "t2.micro"
  key_name      = "ansible-key"
  #add network interfaces to the launch template
  network_interfaces {
    associate_public_ip_address = true
    device_index                = 0
    subnet_id                   = "subnet-09acd2d431e53234e"
    security_groups             = ["sg-09a675e5396be5d5b"]
    delete_on_termination       = true
  }
  #vpc_security_group_ids = ["sg-09a675e5396be5d5b"]
  #add launch template version to the launch template

  user_data = filebase64("user_data.sh")
}


resource "aws_instance" "example" {
  launch_template {
    id      = aws_launch_template.user_data_template.id
    version = "$Latest"
  }

  tags = {
    Name = "user-data-with-launch-template"
  }
}



# ############sample 2 using block_device_mappings##########
# variable "user_data_script" {
#   type = string
#   default = <<-EOF
#     #!/bin/bash
#     echo "Hello, World!" > index.html
#     nohup python -m SimpleHTTPServer 80 &
#   EOF
# }
#
# resource "aws_launch_template" "web_server" {
#   # ... other launch template configuration ...
#
#   user_data = base64encode(var.user_data_script)
#
#   # ... other launch template configuration ...
# }


