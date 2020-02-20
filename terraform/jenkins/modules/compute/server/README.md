## Purpose
Jenkins server host and ingresses.

This is for "distributed" "instances" of cicdenv jenkins
where the build agents are run on separate dedicated hosts.

## Ingresses
* external
  * https (alb:443)
* internal
  * https (alb:443)
  * ssh (host:22)
