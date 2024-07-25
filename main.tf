provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_service_plan" "example" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "B1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "example" {
  name                = "example-appservice-unique-1234"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
    app_command_line = "echo 'Hello World' > /home/site/wwwroot/index.html && tail -f /dev/null"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }

  tags = {
    environment = "Terraform"
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]
  }
}



