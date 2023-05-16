provider "azurerm" {
  features {}
  subscription_id   = "${var.subscription_id}"
  tenant_id         = "${var.tenant_id}"
  client_id         = "${var.client_id}"
  client_secret     = "${var.client_secret}"
}

variable "subscription_id" {
     description = "Enter Azure Subscription ID for provisioning Resources in azure"
  
}
variable "client_id" {
    description = "Enter Client ID for application created in azure AD"
  
}
variable "tenant_id" {
    description = "Enter Dirrectory/Tenant ID of your Azure AD"
  
}
variable "client_secret" {
    description = "Enter Client seceret which is App ID for application created in azure AD"
  
}