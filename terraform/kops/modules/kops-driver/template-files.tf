variable "template_files" {
  default = [
    "backend.tf",
    "README.md",
  ]
}

locals {
  strip_workspace = "/-${terraform.workspace}$/"
}

data "template_file" "template_files" {
  count = length(var.template_files)

  template = file("${path.module}/templates/${var.template_files[count.index]}.tpl")

  vars = {
    workspace        = terraform.workspace
    cluster_instance = replace(local.cluster_short_name, local.strip_workspace, "")
  }
}

resource "local_file" "template_files" {
  count = length(var.template_files)

  content  = data.template_file.template_files[count.index].rendered
  filename = "${local.working_dir}/${var.template_files[count.index]}"
}
