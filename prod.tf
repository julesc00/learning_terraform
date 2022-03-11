provider "aws" {
  profile   = "default"
  region    = "us-east-1"
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket  = "tf-briones-course-20220310"
}

resource "aws_default_vpc" "default" {}

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

# This was a nginx instance chosen from the marketplace.
resource "aws_instance" "prod_web" {
  ami         = "ami-023cd9fc317ea7e5d"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]

  tags = {
    "Terraform": "true"
  }
}

# Provision a static IP = eip (AWS Elastic IP)
resource "aws_eip" "prod_web" {
  instance = aws_instance.prod_web.id

  tags = {
    "Terraform": "true"
  }
}