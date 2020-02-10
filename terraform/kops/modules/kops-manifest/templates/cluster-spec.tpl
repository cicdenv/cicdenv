---
apiVersion: kops/v1alpha2
kind: Cluster
metadata:
  name: ${cluster_name}
spec:
  addons:
  - manifest: s3://${state_store}/${cluster_name}/addons/custom-channel.yaml
  api:
    loadBalancer:
      type: Internal
      additionalSecurityGroups: ${lb_security_groups}
  authentication:
    aws: {}
  authorization:
    rbac: {}
  channel: stable
  cloudProvider: aws
  configBase: s3://${state_store}/${cluster_name}
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
  kubernetesApiAccess:
  - 0.0.0.0/0
  kubelet:
    anonymousAuth: false
  kubernetesVersion: ${kubernetes_version}
  masterInternalName: api.internal.${cluster_name}
  masterPublicName: api.${cluster_name}
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
    auditLogPath:       /var/log/kube-apiserver-audit.log
    auditPolicyFile:    /srv/kubernetes/audit.yaml
    auditLogMaxAge:       10 # Days
    auditLogMaxBackups:    1 # Logs to retain
    auditLogMaxSize:     100 # Max size in MB