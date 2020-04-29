## Links
* https://opendev.org/jjb/python-jenkins
* https://python-jenkins.readthedocs.io/en/latest/api.html

* https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_best_practices.html

## Samples
```python
from jenkins import Jenkins

server = Jenkins(server_name, username=github_user, password=github_token, timeout=10)
info = server.get_info()
```
```json
{
  "mode": "NORMAL",
  "overallLoad": {},
  "quietingDown": true,
  "url": "https://jenkins-<instance>.<workspace>.<domain>/",
  "useCrumbs": true,
  "useSecurity": true
}
```
