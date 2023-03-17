terraform {
  required_providers {
    azuredevops = {
      source  = "registry.terraform.io/microsoft/azuredevops"
      version = "=0.2.1"
    }
  }
  required_version = "~> 1.4.0"
}
