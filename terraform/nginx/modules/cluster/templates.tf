data "template_file" "nginx_environment" {
  template = file("${path.module}/templates/etc/systemd/system/nginx.env.tpl")

  vars = {
    tag = local.image_tag
  }
}

data "template_file" "nginx_service" {
  template = file("${path.module}/templates/etc/systemd/system/nginx.service.tpl")

  vars = {
    host_name = local.host_name
    ecr_url   = local.nginx_image.repository_url
    image     = local.nginx_image.name

    aws_region = data.aws_region.current.name
    
    aws_main_account_id = local.main_account.id
    
    aws_account_alias = terraform.workspace
  }
}
