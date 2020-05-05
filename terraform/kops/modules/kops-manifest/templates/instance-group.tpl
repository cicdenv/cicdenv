---
apiVersion: kops/v1alpha2
kind: InstanceGroup
metadata:
  labels:
    kops.k8s.io/cluster: ${cluster_name}
  name: ${name}
spec:
  image: ${ami}
  machineType: ${instance_type}
  maxSize: ${max_size}
  minSize: ${min_size}
  nodeLabels:
    kops.k8s.io/instancegroup: ${name}
  role: ${role}
  rootVolumeSize: ${root_volume_size}
  iam:
    profile: ${iam_profile_arn}
  additionalSecurityGroups: ${security_groups}
  subnets:
${subnet_names}
  cloudLabels:
${cloud_labels}
  detailedInstanceMonitoring: true