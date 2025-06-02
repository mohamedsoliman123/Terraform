# Create Resource Group TerrformRG
resource "azurerm_resource_group" "RG"{
    location = var.RG_Location
    name    =   var.RG_Name
    tags    ={
        Company ="SoliTech"
        Project = "Deploy RG as a Code."
    }
}