## Purpose
Jenkins server host and ingresses.

This is for "distributed" "instances" of cicdenv jenkins
where the build agents are run on separate dedicated hosts.

## Ingresses
* external
  * https (alb:443)
  * ssh (nlb:16022)
* internal
  * https (alb:443)
  * ssh (nlb:16022)
  * agent (nlb:5000)
