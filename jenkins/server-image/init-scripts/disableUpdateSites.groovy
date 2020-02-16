import jenkins.model.Jenkins
import hudson.model.UpdateSite

for (UpdateSite site : Jenkins.instance.getUpdateCenter().getSiteList()) {
    site.neverUpdate = true
    site.data = null
    site.dataTimestamp = 0
    site.lastAttempt = -1
    
    new File(Jenkins.instance.getRootDir(), "updates/${site.id}.json").delete()
}

/*
  Disables Update Center background checks.

  https://wiki.jenkins-ci.org/display/JENKINS/Features+controlled+by+system+properties
*/
System.setProperty('hudson.model.UpdateCenter.never', 'true')
