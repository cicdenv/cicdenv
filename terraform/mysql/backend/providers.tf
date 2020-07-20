provider "aws" {
  region = var.region
  
  profile = "admin-main"
}

provider "acme" {
  # https://letsencrypt.org/docs/acme-protocol-updates/
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
