terraform {

  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.94.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "4.12.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "remote-state"
    storage_account_name = "juliocardosoremotestate"
    container_name       = "remote-state"
    key                  = "pipeline-github-actions/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"
  config = {
    resource_group_name  = "remote-state"
    storage_account_name = "juliocardosoremotestate"
    container_name       = "remote-state"
    key                  = "azure-vnet/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      owner      = "juliocardoso"
      managed-by = "terraform"
    }
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "juliocardoso-remote-state"
    key    = "aws-vpc/terraform.tfstate"
    region = "eu-central-1"
  }
}