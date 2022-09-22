# with a map
resource "azurerm_resource_group" "rg" {
  for_each = {
    a_group = "eastus"
    another_group = "westus2"
  }

  location = each.value
  name     = each.key
}

# with a set of strings
resource "aws_iam_user" "the-accounts" {
  for_each = toset( ["Julito", "Jamal", "Cari", "Punky"] )
  name = each.key
}

# with a child module
module "bucket" {
  for_each = toset( ["assets", "media"] )
  source = "./publish_bucket"
  name = "${each.key}_bucket"
}

variable "name" {}  # this is the input parameter of the module

resource "aws_s3_bucket" "example" {
  # Because var.name includes each.key in the calling
  # module block, its value will be different for
  # each instance of this module.
  bucket = var.name
  # ...
}

resource "aws_iam_user" "deploy_user" {
  # ...
}