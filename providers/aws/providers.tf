terraform {
    cloud {
        # Note: Because the cloud block is not supported by older versions of Terraform, 
        # you must use 1.1.0 or higher in order to follow this tutorial. Previous versions 
        # can use the remote backend block to configure the CLI workflow and migrate state.
        organization = "Organization Name"
        workspaces {
            name = "Example-Workspace"
        }
    }

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.16"
        }
    }

    required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}