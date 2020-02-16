data "template_file" "default_action_page" {
  template = file("${path.module}/templates/default-action-page.html.tpl")

  vars = {
    domain = local.domain
  }
}
