locals {
  modules = csvdecode(file("${path.module}/terraform_modules.csv"))
}

resource "spacelift_module" "from_csv" {
  for_each = {
    for module in local.modules : module.module_name => module
    if module.spacelift_module_required == "true"
  }

  name        = each.value.module_name
  description = "Terraform module for ${each.value.project}"
  branch      = "main"
  repository  = var.repository  
  labels      = [each.value.project]
}

variable "repository" {
  description = "Repository name where the modules are stored"
  type        = string
}
