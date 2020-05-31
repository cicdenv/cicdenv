apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
metadata:
  name: pod-identity-webhook
  namespace: kube-system
webhooks:
  - name: pod-identity-webhook.amazonaws.com
    failurePolicy: Ignore
    clientConfig:
      service:
        name: pod-identity-webhook
        namespace: kube-system
        path: "/mutate"
      caBundle: ${tls_cert}
    rules:
      - apiGroups: [""]
        apiVersions: ["v1"]
        resources: ["pods"]
        operations: [ "CREATE" ]
