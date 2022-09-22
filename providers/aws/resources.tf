
resource "aws_instance" "app_server" {
  ami           = "ami-1a2b3c4d"
  instance_type = "t2.micro"

  tags = {
    "Name" = var.instance_name
  }
}
