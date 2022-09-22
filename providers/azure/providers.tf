terraform {
  # Store remote state
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.16.0"
    }
  }

  cloud {
      organization = "Organization Name"
      workspaces {
          name = "learn-terraform-azure"
      }
  }
}

provider "azurerm" {
  features {}
}
