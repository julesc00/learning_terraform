# Variable definitions
variable "whitelist" {
  type = list(string)
}
variable "web_image_id" {
  type = string
}
variable "web_instance_type" {
  type = string
}
variable "web_desired_capacity" {
  type = number
}
variable "web_max_size" {
  type = number
}
variable "web_min_size" {
  type = number
}


provider "aws" {
  profile   = "default"
  region    = "us-east-1"
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket  = "tf-briones-course-20220310"
}

resource "aws_default_vpc" "default" {}

# Subnet resources --Start--
resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"

  tags = {
    "Terraform": "true"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-east-1b"

  tags = {
    "Terraform": "true"
  }
}
# Subnet resources --End--

resource "aws_security_group" "prod_web" {
  name = "prod_web"
  description = "Allow standard http and https ports inbound and everything outbound"

  ingress {
    # http
    from_port     = 80
    protocol      = "tcp"
    to_port       = 80
    cidr_blocks   = var.whitelist
  }
  ingress {
    # https
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = var.whitelist
  }
  egress {
    from_port = 0
    protocol  = "-1"  # Allow all
    to_port   = 0
    cidr_blocks = var.whitelist
  }

  tags = {
    "Terraform" : "true"
  }
}

# Load Balancer resources --Start--
resource "aws_elb" "prod_web" {
  name                = "prod-web"
  subnets             = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  security_groups     = [aws_security_group.prod_web.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  tags = {
    "Terraform": "true"
  }
}
# Load Balancer resources --End--

# Challenge Auto Scaling Group (ASG) ---Start---
resource "aws_launch_template" "prod_web" {
  name_prefix = "prod-web"
  image_id = var.web_image_id
  instance_type = var.web_instance_type

  tags = {
    "Terraform": "true"
  }
}

resource "aws_autoscaling_group" "prod_web" {
  desired_capacity    = var.web_desired_capacity
  max_size            = var.web_max_size
  min_size            = var.web_min_size
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]

  launch_template {
    id  = aws_launch_template.prod_web.id
    version = "$Latest"
  }
  tag {
    key                 = "Terraform"
    propagate_at_launch = true
    value               = "true"
  }
}

resource "aws_autoscaling_attachment" "prod_web" {
  autoscaling_group_name = aws_autoscaling_group.prod_web.id
  elb = aws_elb.prod_web.id
}
# Challenge Auto Scaling Group (ASG) ---End---
