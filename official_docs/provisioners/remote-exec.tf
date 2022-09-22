# Example usage
# Docs: https://www.terraform.io/language/resources/provisioners/remote-exec

resource "aws_instance" "web" {
  # ... 

  # Establishes connection to be used by all generic
  # remote provisioners (i.e. file/remote-exec)
  connection {
      type      = "ssh"
      user      = "root"
      password  = var.root_password
      host      = self.public_ip
  }

  provisioner "remote-exec" {
      inline = [
          "puppet apply",
          "consul join ${aws_instance.web.public_ip}",
      ]
  }
}


# Example 2
resource "aws_instance" "web2" {
  # ... 

  provisioner "file" {
      source        = "script.sh"
      destination   = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
      inline = [
          "chmod +x /tmp/script.sh",
          "/tmp/script.sh args",
      ]
  
  }
}