# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "gdykeman-rg" {
  name     = "gdykeman-rg"
  location = "East US"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "gdykeman-network" {
  name                = "gdykeman-network"
  resource_group_name = azurerm_resource_group.gdykeman-rg.name
  location            = azurerm_resource_group.gdykeman-rg.location
  address_space       = ["10.0.0.0/16"]
}