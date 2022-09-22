terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "~> 4.31.0"
        }
    }
}

provider "google" {
    credentials = file("creds.json")

    project = "web-app2"
    region = "us-central1"
    zone = "us-central1-c"
}