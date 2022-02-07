/**
 * # azuredevops_project
 *
 * This module manages Azure DevOps Projects.
 *
*/
resource "azuredevops_project" "project" {
  for_each = var.project

  name               = local.project[each.key].name == "" ? each.key : local.project[each.key].name
  description        = local.project[each.key].description
  visibility         = local.project[each.key].visibility
  version_control    = local.project[each.key].version_control
  work_item_template = local.project[each.key].work_item_template

  features = {
    boards       = local.project[each.key].features.boards
    repositories = local.project[each.key].features.repositories
    pipelines    = local.project[each.key].features.pipelines
    testplans    = local.project[each.key].features.testplans
    artifacts    = local.project[each.key].features.artifacts
  }
}

resource "azuredevops_serviceendpoint_azurerm" "serviceendpoint_azurerm" {
  for_each = var.serviceendpoint_azurerm

  service_endpoint_name     = local.serviceendpoint_azurerm[each.key].service_endpoint_name == "" ? each.key : local.serviceendpoint_azurerm[each.key].service_endpoint_name
  project_id                = local.serviceendpoint_azurerm[each.key].project_id
  azurerm_spn_tenantid      = local.serviceendpoint_azurerm[each.key].azurerm_spn_tenantid
  azurerm_subscription_id   = local.serviceendpoint_azurerm[each.key].azurerm_subscription_id
  azurerm_subscription_name = local.serviceendpoint_azurerm[each.key].azurerm_subscription_name
  description               = local.serviceendpoint_azurerm[each.key].description
  dynamic "credentials" {
    for_each = local.serviceendpoint_azurerm[each.key].credentials == {} ? [0] : [1]

    content {
      serviceprincipalid  = local.serviceendpoint_azurerm[each.key].credentials.serviceprincipalid
      serviceprincipalkey = local.serviceendpoint_azurerm[each.key].credentials.serviceprincipalkey
    }
  }
}

resource "azuredevops_serviceendpoint_azurecr" "serviceendpoint_azurecr" {
  for_each = var.serviceendpoint_azurecr

  service_endpoint_name     = local.serviceendpoint_azurecr[each.key].service_endpoint_name == "" ? each.key : local.serviceendpoint_azurecr[each.key].service_endpoint_name
  project_id                = local.serviceendpoint_azurecr[each.key].project_id
  resource_group            = local.serviceendpoint_azurecr[each.key].resource_group
  azurecr_spn_tenantid      = local.serviceendpoint_azurecr[each.key].azurecr_spn_tenantid
  azurecr_name              = local.serviceendpoint_azurecr[each.key].azurecr_name
  azurecr_subscription_id   = local.serviceendpoint_azurecr[each.key].azurecr_subscription_id
  azurecr_subscription_name = local.serviceendpoint_azurecr[each.key].azurecr_subscription_name
  description               = local.serviceendpoint_azurecr[each.key].description
}

resource "azuredevops_serviceendpoint_dockerregistry" "serviceendpoint_dockerregistry" {
  for_each = var.serviceendpoint_dockerregistry

  service_endpoint_name = local.serviceendpoint_dockerregistry[each.key].service_endpoint_name == "" ? each.key : local.serviceendpoint_dockerregistry[each.key].service_endpoint_name
  project_id            = local.serviceendpoint_dockerregistry[each.key].project_id
  description           = local.serviceendpoint_generic_git[each.key].description
  docker_registry       = local.serviceendpoint_generic_git[each.key].docker_registry
  docker_username       = local.serviceendpoint_generic_git[each.key].docker_username
  docker_email          = local.serviceendpoint_generic_git[each.key].docker_email
  docker_password       = local.serviceendpoint_generic_git[each.key].docker_password
  registry_type         = local.serviceendpoint_generic_git[each.key].registry_type
}

resource "azuredevops_serviceendpoint_generic_git" "serviceendpoint_generic_git" {
  for_each = var.serviceendpoint_generic_git

  service_endpoint_name   = local.serviceendpoint_generic_git[each.key].service_endpoint_name == "" ? each.key : local.serviceendpoint_generic_git[each.key].service_endpoint_name
  project_id              = local.serviceendpoint_generic_git[each.key].project_id
  repository_url          = local.serviceendpoint_generic_git[each.key].repository_url
  username                = local.serviceendpoint_generic_git[each.key].username
  password                = local.serviceendpoint_generic_git[each.key].password
  description             = local.serviceendpoint_generic_git[each.key].description
  enable_pipelines_access = local.serviceendpoint_generic_git[each.key].enable_pipelines_access
}

resource "azuredevops_variable_group" "variable_group" {
  for_each = var.variable_group

  name         = local.variable_group[each.key].name == "" ? each.key : local.variable_group[each.key].name
  project_id   = local.variable_group[each.key].project_id
  description  = local.variable_group[each.key].description
  allow_access = local.variable_group[each.key].allow_access

  dynamic "variable" {
    for_each = local.variable_group[each.key].variable

    content {
      name         = local.variable_group[each.key].variable[variable.key].name == "" ? each.key : local.variable_group[each.key].variable[variable.key].name
      value        = local.variable_group[each.key].variable[variable.key].value
      secret_value = local.variable_group[each.key].variable[variable.key].secret_value
      is_secret    = local.variable_group[each.key].variable[variable.key].is_secret
    }
  }
}
