data "aws_ami" "example" {
  most_recent = true

  owners = ["self"]
  tags = {
      Name      = "app-server"
      Tested    = "true"
  }
}

# Custom Condition Checks
data "aws_ami" "example2" {
  id = var.aws_ami_id

  lifecycle {
    # The AMI ID must refer to an existing AMI that has the tag "nomad-server"
    postcondition {
      condition     = self.tags["Component"] == "nomad-server"
      error_message = "tags[\"Component\"] must be \"nomad-server\"."
    }
  }
}

# Lifecycle Customizations; a data source configuration
data "aws_ami" "web" {
  filter {
    name      = "state"
    values    = ["available"]
  }
  
  filter {
    name      = "tag:Component"
    values    = ["web"]
  }

  most_recent = true
}