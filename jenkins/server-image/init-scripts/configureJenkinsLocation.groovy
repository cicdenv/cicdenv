import jenkins.model.JenkinsLocationConfiguration

/*
$JENKINS_HOME/jenkins.model.JenkinsLocationConfiguration.xml

<jenkins.model.JenkinsLocationConfiguration>
  <adminAddress>{ADMIN_EMAIL}</adminAddress>
  <jenkinsUrl>{JENKINS_URL}</jenkinsUrl>
</jenkins.model.JenkinsLocationConfiguration>
*/

def jlc = JenkinsLocationConfiguration.get()

def serverUrl = System.env.SERVER_URL
def adminAddress = System.env.ADMIN_EMAIL ?: 'admin+jenkins@cicdenv.com'

if (jlc.getUrl() != serverUrl) {
    println "Configured jenkins.model.JenkinsLocationConfiguration::url => ${serverUrl}"

    jlc.setUrl(serverUrl)
}

if (jlc.getAdminAddress() != adminAddress) {
    println "Configured jenkins.model.JenkinsLocationConfiguration::adminAddress => ${adminAddress}"

    jlc.setAdminAddress(adminAddress)
}
