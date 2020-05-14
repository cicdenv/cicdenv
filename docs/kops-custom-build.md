## Go Version Manager
```
gvm install|list ...
gvm use go1.14.2
gvm pkgset create --local
gvm pkgset use --local
echo $GOPATH

go get -d k8s.io/kops

cd "${GOPATH%%:*}/src/k8s.io/kops/"
$ git log --oneline -1
a454f0f Merge pull request #9118 from johngmyers/validate-missing-asg

make
../../../bin/kops version
Version 1.18.0-alpha.3 (git-a454f0f)

"${GOPATH%%:*}/bin/kops"
```

## Links
* https://github.com/vogtech/localenv/tree/master/golang
* https://kops.sigs.k8s.io/
  * https://kops.sigs.k8s.io/development/building/
* https://github.com/vogtech/cicdenv/issues/146
* https://github.com/kubernetes/kops/issues/9100
  * https://github.com/kubernetes/kops/pull/9118
    * https://github.com/kubernetes/kops/commit/a454f0ff830885845fb38d3d42f73945fcb0a88c
