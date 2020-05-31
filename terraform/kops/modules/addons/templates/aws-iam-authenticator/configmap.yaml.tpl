---
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: kube-system
  name: aws-iam-authenticator
  labels:
    k8s-app: aws-iam-authenticator
data:
  config.yaml: |
    clusterID: ${cluster_id}
    server:
      mapUsers:
${admin_users}
      mapRoles:
${admin_roles}
