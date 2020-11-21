apiVersion: v1
kind: Config
clusters:
- name: ${cluster_name}
  cluster:
    certificate-authority-data: ${ca_data}
    server: https://api.${cluster_name}
users:
- name: iam.${cluster_name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: ${command}
      args:
        - token
        - -i
        - ${cluster_name}
      env:
        - name: AWS_PROFILE
          value: admin-${workspace}
contexts:
- name: ${cluster_name}
  context:
    cluster: ${cluster_name}
    user: iam.${cluster_name}
current-context: ${cluster_name}
