output "project" {
  description = "azuredevops_project results"
  value = {
    for project in keys(azuredevops_project.project) :
    project => {
      id                  = azuredevops_project.project[project].id
      process_template_id = azuredevops_project.project[project].process_template_id
    }
  }
}

output "serviceendpoint_generic_git" {
  description = "azuredevops_serviceendpoint_generic_git results"
  value = {
    for serviceendpoint in keys(azuredevops_serviceendpoint_generic_git.serviceendpoint_generic_git) :
    serviceendpoint => {
      id                    = azuredevops_serviceendpoint_generic_git.serviceendpoint_generic_git[serviceendpoint].id
      service_endpoint_name = azuredevops_serviceendpoint_generic_git.serviceendpoint_generic_git[serviceendpoint].service_endpoint_name
    }
  }
}

output "variable_group" {
  description = "azuredevops_variable_group results"
  value = {
    for variable_group in keys(azuredevops_variable_group.variable_group) :
    variable_group => {
      id   = azuredevops_variable_group.variable_group[variable_group].id
      name = azuredevops_variable_group.variable_group[variable_group].name
    }
  }
}
