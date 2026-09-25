terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "azurerm" {
  features {}
}

resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "day17-multicloud-aws-vpc"
  }
}

resource "azurerm_resource_group" "main" {
  name     = "day17-pathnex-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "main" {
  name                = "pathnex-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.20.0.0/16"]
}
