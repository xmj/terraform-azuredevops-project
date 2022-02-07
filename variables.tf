variable "project" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "serviceendpoint_azurerm" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "serviceendpoint_azurecr" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "serviceendpoint_dockerregistry" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "serviceendpoint_generic_git" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "variable_group" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}

locals {
  default = {
    # resource definition
    project = {
      name               = ""
      description        = "NFT Marketplaces"
      visibility         = "private"
      version_control    = "Git"
      work_item_template = "Basic"
      features = {
        boards       = "disabled"
        repositories = "disabled"
        pipelines    = "disabled"
        testplans    = "disabled"
        artifacts    = "disabled"
      }
    }
    serviceendpoint_azurerm = {
      service_endpoint_name = ""
      description           = "Managed by Terraform"
      credentials           = {}
      resource_group        = ""
    }
    serviceendpoint_azurecr = {
      service_endpoint_name = ""
      description           = "Managed by Terraform"
    }
    serviceendpoint_dockerregistry = {
      service_endpoint_name = ""
      description           = ""
      docker_registry       = ""
      docker_username       = ""
      docker_email          = ""
      docker_password       = ""
      registry_type         = "DockerHub"
    }
    serviceendpoint_generic_git = {
      service_endpoint_name   = ""
      enable_pipelines_access = false
      description             = "Managed by Terraform"
      username                = ""
      password                = ""
    }
    variable_group = {
      name         = ""
      description  = ""
      allow_access = true
      variable = {
        name         = ""
        value        = ""
        secret_value = ""
        is_secret    = false
      }
    }
  }

  # compare and merge custom and default values
  project_values = {
    for project in keys(var.project) :
    project => merge(local.default.project, var.project[project])
  }
  variable_group_values = {
    for variable_group in keys(var.variable_group) :
    variable_group => merge(local.default.variable_group, var.variable_group[variable_group])
  }

  # merge all custom and default values
  project = {
    for project in keys(var.project) :
    project => merge(
      local.project_values[project],
      {
        for config in ["features"] :
        config => merge(local.default.project[config], local.project_values[project][config])
      }
    )
  }
  serviceendpoint_azurerm = {
    for serviceendpoint_azurerm in keys(var.serviceendpoint_azurerm) :
    serviceendpoint_azurerm => merge(local.default.serviceendpoint_azurerm, var.serviceendpoint_azurerm[serviceendpoint_azurerm])
  }
  serviceendpoint_azurecr = {
    for serviceendpoint_azurecr in keys(var.serviceendpoint_azurecr) :
    serviceendpoint_azurecr => merge(local.default.serviceendpoint_azurecr, var.serviceendpoint_azurecr[serviceendpoint_azurecr])
  }
  serviceendpoint_dockerregistry = {
    for serviceendpoint_dockerregistry in keys(var.serviceendpoint_dockerregistry) :
    serviceendpoint_dockerregistry => merge(local.default.serviceendpoint_dockerregistry, var.serviceendpoint_dockerregistry[serviceendpoint_dockerregistry])
  }
  serviceendpoint_generic_git = {
    for serviceendpoint_generic_git in keys(var.serviceendpoint_generic_git) :
    serviceendpoint_generic_git => merge(local.default.serviceendpoint_generic_git, var.serviceendpoint_generic_git[serviceendpoint_generic_git])
  }
  variable_group = {
    for variable_group in keys(var.variable_group) :
    variable_group => merge(
      local.variable_group_values[variable_group],
      {
        for config in ["variable"] :
        config => {
          for key in keys(local.variable_group_values[variable_group][config]) :
          key => merge(local.default.variable_group[config], local.variable_group_values[variable_group][config][key])
        }
      }
    )
  }

}
