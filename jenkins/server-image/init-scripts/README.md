Scripts for configuring the jenkins server during startup.

NOTE:
```
Bootstrapping a jenkins server this way is not the "final" solution.
Just an expedient means of acheiving a fully self configuring jenkins server image.

Eventually (ideally) a single script entry point driven by an input file(s) will replace these.

Maybe Jenkins Configuration As Code (jcasc) can be used to perform some of these functions now.
```

## ThirdParty
* https://github.com/karfunkel/ConfigParser
* http://docs.groovy-lang.org/2.4.9/html/gapi/groovy/util/ConfigSlurper.html

## Items
agent-to-master access control: kill switch
credentials
csrf protection
github
  settings
  authz strategy
  endpoints
  oauth
  scm
global shared libraries
jenkins location
agent protocols
scriptler settings
simple theme CSS
slack
system settings
disable
  slack outbound webhooks
  update sites
  usage stats

## ENV vars
```
SERVER_URL
JENKINS_INSTANCE

GITHUB_ORGANIZATION
GITHUB_AGENT_USER
GITHUB_SECRET_ARN
```

Script cleanup:
```
[ ] .gitconfig => configureGitSCM.groovy
[ ] scriptler => source console-scripts
[ ] hard-coded simple theme settings
  [ ] check current values before setting not consistent in all scripts
```

## Links
* https://wiki.jenkins.io/display/JENKINS/Groovy+Hook+Script
* https://groovy-lang.org/documentation.html
* https://learnxinyminutes.com/docs/groovy/
