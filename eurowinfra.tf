# Create a resource group
resource "azurerm_resource_group" "eurow_RG" {
  name     = "eurow_RG"
  location = "uae north"
}
# Create a virtual network
resource "azurerm_virtual_network" "eurow-vnet" {
  name                = "eurow-vnet"
  address_space       = ["172.16.0.0/16"]
  location            = azurerm_resource_group.eurow_RG.location
  resource_group_name = azurerm_resource_group.eurow_RG.name
}
# Create subnets within the virtual network
resource "azurerm_subnet" "staging_subnet" {
  name                 = "staging-subnet"
  resource_group_name  = azurerm_resource_group.eurow_RG.name
  virtual_network_name = azurerm_virtual_network.eurow-vnet.name
  address_prefixes     = ["172.16.0.0/24"]
}

resource "azurerm_subnet" "production_subnet" {
  name                 = "production-subnet"
  resource_group_name  = azurerm_resource_group.eurow_RG.name
  virtual_network_name = azurerm_virtual_network.eurow-vnet.name
  address_prefixes     = ["172.16.1.0/24"]
}

# Create an App Service plan for staging environment
resource "azurerm_service_plan" "staging" {
  name                = "staging-app-service-plan"
  location            = azurerm_resource_group.eurow_RG.location
  resource_group_name = azurerm_resource_group.eurow_RG.name
  os_type             = "Linux"
  sku_name            = "S1"
}
# Create an App Service plan for production environment
resource "azurerm_service_plan" "production" {
  name                = "production-app-service-plan"
  location            = azurerm_resource_group.eurow_RG.location
  resource_group_name = azurerm_resource_group.eurow_RG.name
  os_type             = "Linux"
  sku_name            = "S1"
}
# Create an API Management service
resource "azurerm_api_management" "eurow-apim" {
  name                = "eurow-apim"
  location            = azurerm_resource_group.eurow_RG.location
  resource_group_name = azurerm_resource_group.eurow_RG.name
  publisher_name      = "Eurowings digital"
  publisher_email     = "ambrozyfex@gmail.com"
  sku_name            = "Developer_1"
  virtual_network_type = "External"
  virtual_network_configuration {
      subnet_id = azurerm_subnet.staging_subnet.id
  }
  depends_on = [
    azurerm_service_plan.staging,
    azurerm_service_plan.production,
  ]
}
