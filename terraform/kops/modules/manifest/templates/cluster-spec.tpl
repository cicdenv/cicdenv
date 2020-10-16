---
apiVersion: kops/v1alpha2
kind: Cluster
metadata:
  name: ${cluster_fqdn}
spec:
  metricsServer:
    enabled: true
  addons:
  - manifest: s3://${state_store}/${cluster_fqdn}/addons/custom-channel.yaml
  api:
    loadBalancer:
      type: Internal
      useApiInternal: true
      crossZoneLoadBalancing: true
      additionalSecurityGroups: ${lb_security_groups}
  authentication:
    aws: {}
  authorization:
    rbac: {}
  channel: stable
  cloudProvider: aws
  configBase: s3://${state_store}/${cluster_fqdn}
  dnsZone: ${private_dns_zone}
  etcdClusters:
  - etcdMembers:
${etcd_members}
    name: main
  - etcdMembers:
${etcd_members}
    name: events
  iam:
    allowContainerRegistry: true
    legacy: false
  kubeDNS:
    provider: CoreDNS
    nodeLocalDNS:
      enabled: true
  kubernetesApiAccess:
  - 0.0.0.0/0
  kubelet:
    anonymousAuth: false
    authorizationMode: Webhook
    authenticationTokenWebhook: true
  kubernetesVersion: ${kubernetes_version}
  masterInternalName: api.${cluster_fqdn}
  masterPublicName: api.${cluster_fqdn}
  networkCIDR: ${network_cidr}
  networkID: ${vpc_id}
  networking:
    ${networking}: {}
  nonMasqueradeCIDR: 100.64.0.0/10
  subnets:
${private_subnets}
${public_subnets}
  topology:
    dns:
      type: Private
    masters: private
    nodes: private
  fileAssets:
  - name: kubernetes-audit
    path: /srv/kubernetes/audit.yaml
    roles: [Master]
    content: |
      ${audit_policy}
  kubeAPIServer:
    ${irsa_kube_api_args}
    auditLogPath:       /var/log/kube-apiserver-audit.log
    auditPolicyFile:    /srv/kubernetes/audit.yaml
    auditLogMaxAge:       10 # Days
    auditLogMaxBackups:    1 # Logs to retain
    auditLogMaxSize:     100 # Max size in MB
  docker:
    skipInstall: true
  containerd:
    skipInstall: true
