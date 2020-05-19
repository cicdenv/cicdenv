data "template_file" "org_account_admin_roles" {
  count = length(var.accounts)
  
  template = "arn:aws:iam::$${account_id}:role/$${role_name}"

  vars = {
    role_name = "${lookup(var.accounts[count.index], "name")}-admin"
    # role_name  = aws_organizations_account.accounts[count.index].role_name
    account_id = aws_organizations_account.accounts[count.index].id
  }
}

data "template_file" "main_root" {
  template = "arn:aws:iam::$${account_id}:root"

  vars = {
    account_id = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "org_account_roots" {
  count = length(aws_organizations_account.accounts.*.id)
  
  template = "arn:aws:iam::$${account_id}:root"

  vars = {
    account_id = aws_organizations_account.accounts[count.index].id
  }
}

output "org_account_admin_roles" {
  value = data.template_file.org_account_admin_roles.*.rendered
}

output "org_account_roots" {
  value = data.template_file.org_account_roots.*.rendered
}

output "all_account_roots" {
  value = flatten([data.template_file.main_root.rendered, data.template_file.org_account_roots.*.rendered])
}

output "main_account_root" {
  value = data.template_file.main_root.rendered
}

output "org_account_ids" {
  value = aws_organizations_account.accounts.*.id
}

output "master_account" {
  value = {
    id = data.aws_caller_identity.current.account_id
    alias = data.aws_iam_account_alias.current.account_alias
  }
}

output "account_names" {
  value = aws_organizations_account.accounts.*.name
}

output "account_ids_by_name" {
  value = zipmap(aws_organizations_account.accounts.*.name, 
                 aws_organizations_account.accounts.*.id)
}

data "template_file" "account_ous" {
  count = length(var.accounts)

  template = "$${ou}"

  vars = {
    ou = var.accounts[count.index]["ou"]
  }
}

output "account_ous_by_name" {
  value = zipmap(aws_organizations_account.accounts.*.name, 
                 data.template_file.account_ous.*.rendered)
}

output "organization" {
  value = {
    id = aws_organizations_organization.organization.id
  }
}
