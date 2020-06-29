data "template_file" "master_instance_group" {
  for_each = toset(local.etcd_zones)

  template = file("${path.module}/templates/instance-group.tpl")

  vars = {
    name             = "master-${each.key}"
    role             = "Master"
    cluster_fqdn     = local.cluster_fqdn
    ami_id           = local.ami_id
    instance_type    = local.master_instance_type
    max_size         = "1"
    min_size         = "1"
    root_volume_size = local.master_volume_size

    iam_profile_arn = local.iam.master.instance_profile.arn

    security_groups = "[${join(",", local.master_security_groups)}]"

    subnet_name = "private-${each.key}"
    
    addition_user_data = <<EOF
  - name: configure-container-runtime.sh
    type: text/x-shellscript
    content: |
      ${indent(6, file("${path.module}/files/configure-container-runtime.sh"))}
  - name: configure-irsa.sh
    type: text/x-shellscript
    content: |
      #!/bin/bash
      
      set -eu -o pipefail

      IMDSv2_TOKEN=$(curl -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 30" -sL "http://169.254.169.254/latest/api/token")
      export AWS_DEFAULT_REGION=$(curl -H "X-aws-ec2-metadata-token:$IMDSv2_TOKEN" -m5 -sS http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')
      
      mkdir -p /srv/kubernetes/assets
      
      aws secretsmanager get-secret-value                      \
          --secret-id "${local.secrets.service_accounts.arn}"  \
          --version-stage 'AWSCURRENT'                         \
          --query  'SecretString'                              \
      | jq -r 'fromjson | .["account-signing-key"]'            \
      | base64 -di                                             \
      > "/srv/kubernetes/assets/service-account-signing-key"
      chmod 0600 "/srv/kubernetes/assets/service-account-signing-key"
EOF
  }
}
