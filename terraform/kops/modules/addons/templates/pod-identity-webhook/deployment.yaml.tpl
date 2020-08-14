apiVersion: apps/v1
kind: Deployment
metadata:
  name: pod-identity-webhook
  namespace: kube-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: pod-identity-webhook
  template:
    metadata:
      labels:
        app: pod-identity-webhook
    spec:
      tolerations:
        - key: node-role.kubernetes.io/master
          operator: Exists
          effect: NoSchedule
      nodeSelector:
        kubernetes.io/role: master
      serviceAccountName: pod-identity-webhook
      initContainers:
        - name: certificate-init-container
          image: ${initc}
          env:
            - name: NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
          args:
            - -namespace=$(NAMESPACE)
            - -pod-name=$(POD_NAME)
            - -service-names=pod-identity-webhook
            - -query-k8s=true
            - -include-unqualified=true
            - -cert-dir=/etc/tls
          volumeMounts:
            - name: tls
              mountPath: /etc/tls
      containers:
        - name: pod-identity-webhook
          image: ${image}
          imagePullPolicy: Always
          command:
            - /webhook
            - --in-cluster=false
            - --namespace=kube-system
            - --tls-cert=/etc/tls/tls.crt
            - --tls-key=/etc/tls/tls.key
            - --annotation-prefix=${prefix}
            - --token-audience=sts.amazonaws.com
            - --logtostderr
            - --aws-default-region=${region}
            - --token-audience=sts.amazonaws.com
            - --token-expiration=86400
            - --token-mount-path=/var/run/secrets/eks.amazonaws.com/serviceaccount
          volumeMounts:
            - name: tls
              mountPath: /etc/tls
      volumes:
        - name: tls
          emptyDir: {}
