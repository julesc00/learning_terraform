resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami           = "ami-xxxxxxx"
}