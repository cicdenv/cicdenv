## NOTE
These should be edited with care.

KOPS is very specific about what precreated CA cert it will accept.

See the `pki.go` link below.

## Links
* https://kubernetes-kops.netlify.app/custom_ca/
  * https://github.com/kubernetes/kops/blob/master/docs/custom_ca.md
* https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md
* https://github.com/kubernetes/kops/blob/master/docs/cli/kops_create_secret_keypair_ca.md
  * https://github.com/kubernetes/kops/issues/4980
    * https://github.com/kubernetes/kops/blob/master/pkg/model/pki.go#L50 `Subject: cn=kubernetes`
* https://coreos.com/os/docs/latest/generate-self-signed-certificates.html
* https://github.com/cloudflare/cfssl/issues/995
* https://kubernetes.io/docs/setup/best-practices/certificates/
