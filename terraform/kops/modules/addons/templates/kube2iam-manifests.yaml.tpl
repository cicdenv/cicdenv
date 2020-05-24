# https://github.com/jtblin/kube2iam#rbac-setup
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: kube2iam
  namespace: kube-system
  labels:
    app: kube2iam
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: kube2iam
  labels:
    app: kube2iam
rules:
- apiGroups: [""]
  resources: ["namespaces", "pods"]
  verbs: ["get", "watch", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kube2iam
roleRef:
  name: kube2iam
  kind: ClusterRole
  apiGroup: rbac.authorization.k8s.io
subjects:
- kind: ServiceAccount
  name: kube2iam
  namespace: kube-system
# https://github.com/jtblin/kube2iam (release 0.10.7)
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: kube2iam
  namespace: kube-system
  labels:
    app: kube2iam
spec:
  selector:
    matchLabels:
      app: kube2iam
  updateStrategy:
    rollingUpdate:
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: kube2iam
    spec:
      serviceAccountName: kube2iam
      nodeSelector: 
        node-role.kubernetes.io/node: ""
      hostNetwork: true
      containers:
      - name: kube2iam
        image: jtblin/kube2iam:0.10.7
        imagePullPolicy: Always
        args:
        - "--iptables=true"
        - "--host-ip=$(HOST_IP)"
        - "--node=$(NODE_NAME)"
        - "--host-interface=${host_interface}"
        - "--auto-discover-default-role"
        - "--use-regional-sts-endpoint"
        - "--app-port=8181"           # 8181 is the default
        - "--debug"                   # Turns on <node-ip>:8181/debug/store
        - "--metrics-port=8182"
        env:
        - name: AWS_REGION
          value: ${aws_region}
        - name: HOST_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        - name: NODE_NAME
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
        ports:
        - name: http
          containerPort: 8181
          hostPort: 8181
        securityContext:
          privileged: true
