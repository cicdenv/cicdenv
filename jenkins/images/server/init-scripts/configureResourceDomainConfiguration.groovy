import jenkins.security.ResourceDomainConfiguration

/*
$JENKINS_HOME/jenkins.security.ResourceDomainConfiguration.xml
<?xml version='1.1' encoding='UTF-8'?>
<jenkins.security.ResourceDomainConfiguration>
  <url>http://jenkins-server/</url>
</jenkins.security.ResourceDomainConfiguration>
*/

def rdc = ResourceDomainConfiguration.get()

def resourceUrl = System.env.RESOURCE_URL

if (rdc.url != resourceUrl) {
    println "Configured jenkins.security.ResourceDomainConfiguration::url => ${resourceUrl}"

    rdc.url = resourceUrl
}
