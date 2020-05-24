locals {
  template_files = [
    "terraform.tf",
    "README.md",
  ]
}

data "template_file" "template_files" {
  for_each = toset(local.template_files)

  template = file("${path.module}/templates/${each.key}.tpl")

  vars = {
    workspace    = terraform.workspace
    cluster_name = local.cluster_name
  }
}

resource "local_file" "template_files" {
  for_each = toset(local.template_files)

  content  = data.template_file.template_files[each.key].rendered
  filename = "${local.working_dir}/${each.key}"
}
