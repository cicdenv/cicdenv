## Purpose
Ansible playbooks for in-place server/agent updates.

Use cases:
* updating jenkins process images
* updating jenkins config
  * [configuration-as-code:configuration-reload](https://github.com/jenkinsci/configuration-as-code-plugin/blob/master/docs/features/configurationReload.md)

NOTE:  for host changes we'll update the launch configuration 
and terminate the existing instance(s)
