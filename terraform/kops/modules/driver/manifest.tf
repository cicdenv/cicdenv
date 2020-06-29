module "manifest" {
  source = "../manifest"

  # pass thru from terraform/kops/bin/kops.inc
  terraform_state  = var.terraform_state
  cluster_settings = var.cluster_settings
  ami_id           = local.ami_id
  
  cluster_fqdn       = local.cluster_fqdn

  iam = {
    master = {
      instance_profile = {
        arn = aws_iam_instance_profile.kops_master.arn
      }
    }
    node = {
      instance_profile = {
        arn = aws_iam_instance_profile.kops_node.arn
      }
    }
  }

  output_files = {
    manifest = local.manifest
  }
}
