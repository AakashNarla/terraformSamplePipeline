provider "azurerm" {}

resource "azurerm_resource_group" "aks_demo" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}