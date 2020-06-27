## Purpose
Kubernetes addons to install via kops nodeup / addon-manager.

This is how our clusters "self install" customizations on startup.

Items:
* aws-irsa pod-identity-webhook
* webhook certificate auto-approver
* aws-iam-authenticator configuration

## Exports
None.

## Links
* https://kops.sigs.k8s.io/operations/addons
  * https://github.com/kubernetes/kops/blob/master/docs/operations/addons.md
  * https://github.com/kubernetes/kops/tree/master/addons
  * https://github.com/kubernetes/kops/tree/master/upup/models/cloudup/resources/addons
* https://github.com/honestbee/terraform-workshop/tree/master/kops#kops-addon-channels
