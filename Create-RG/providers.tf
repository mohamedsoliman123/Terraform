terraform {
 required_providers {
  azurerm = {
    source  = "hashicorp/azurerm"
      version = "~>4.0"
  }
  random = {
    source  = "hashicorp/random"
    version = "~>3.0
  }
 }
}
provider "azurerm"{
  features {}
  subscription_id ="your subscription_id"
   tenant_id = " you tenant_id"
}