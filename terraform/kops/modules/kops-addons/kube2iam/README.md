## Purpose
This system component is needed to use dynamic IAM role assumption per pod.

## Codebase
https://github.com/jtblin/kube2iam

## Installation
This custom addon is automatically installed during KOPS cluster bootstrap.

## FAQ
* Why not use the community helm chart ?
  * Short answer: using kops channels +s3 integrates more smoothly with terraform

## Debugging
```
# There should be a daemonset
kubectl get      daemonsets/kube2iam --namespace kube-system
kubectl describe daemonsets/kube2iam --namespace kube-system

# 1 Pod should be running per worker node
kubectl get      pods --namespace kube-system --selector app=kube2iam -o wide
kubectl describe pods --namespace kube-system --selector app=kube2iam

# Container logs
kubectl logs -f --namespace kube-system <pod> -c kube2iam

# Debug Store
<node-ip>:8181/debug/store
```

## Reference
* https://github.com/jtblin/kube2iam#options
* https://github.com/helm/charts/tree/master/stable/kube2iam
