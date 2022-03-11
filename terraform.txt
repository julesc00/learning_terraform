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
    cidr_blocks   = ["0.0.0.0/0"]
  }
  ingress {
    # https
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1"  # Allow all
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
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
  image_id = "ami-023cd9fc317ea7e5d"
  instance_type = "t2.micro"

  tags = {
    "Terraform": "true"
  }
}

resource "aws_autoscaling_group" "prod_web" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
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