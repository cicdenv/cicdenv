apiVersion: apps/v1
kind: Deployment
metadata:
  name: tls-approver
  namespace: kube-system
  labels:
    k8s-app: tls-approver
spec:
  replicas: 1
  selector:
    matchLabels:
      k8s-app: tls-approver
  template:
    metadata:
      name: tls-approver
      labels:
        k8s-app: tls-approver
    spec:
      tolerations:
        - key: node-role.kubernetes.io/master
          operator: Exists
          effect: NoSchedule
      nodeSelector:
        kubernetes.io/role: master
      serviceAccountName: kapprover
      containers:
      - name: tls-approver
        image: ${image}
        imagePullPolicy: Always
        ports:
        - containerPort: 8081
          protocol: TCP
        args:
          - -filter=group=system:serviceaccounts
          - -delete-after=1m
        resources:
          requests:
            cpu: 100m
            memory: 50Mi
          limits:
            cpu: 100m
            memory: 50Mi
