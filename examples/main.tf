module "project" {
  source = "registry.terraform.io/T-Systems-MMS/pipelines/project"
  project = {
    project_name = {
      description = "service"
      features = {
        repositories = "enabled"
        pipelines    = "enabled"
      }
    }
  }
  variable_group = {
    pipeline = {
      project_id  = module.project.project["project_name"].id
      description = "Pipeline Settings"
      variable = {
        image = {
          name  = "vmImage"
          value = "ubuntu-latest"
        }
        tenant = {
          name         = "tenant"
          secret_value = data.azurerm_subscription.current.tenant_id
          is_secret    = true
        }
      }
    }
  }
}
