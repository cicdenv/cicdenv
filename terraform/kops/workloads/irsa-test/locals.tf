locals {
  service_account = {
    name = "irsa-test"
  }

  openidc_provider = data.terraform_remote_state.kops_shared.outputs.irsa.oidc.iam.oidc_provider

  builds_bucket = data.terraform_remote_state.kops_backend.outputs.builds.bucket
}
