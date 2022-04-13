# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "gdykeman"

    workspaces {
      name = "Azure"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_loc
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "network" {
  name                = var.network.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = var.network.cidr
}
