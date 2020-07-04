provider "aws" {
  region = var.target_region

  profile = "admin-${terraform.workspace}"
}

provider "acme" {
  # https://letsencrypt.org/docs/acme-protocol-updates/
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
