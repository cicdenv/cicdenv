import jenkins.model.Jenkins
import hudson.slaves.EnvironmentVariablesNodeProperty

def globalNodeProperties = Jenkins.instance.globalNodeProperties
def envVarsNodePropertyList = globalNodeProperties.getAll(EnvironmentVariablesNodeProperty.class)

def envVars = null
if (envVarsNodePropertyList == null || envVarsNodePropertyList.size() == 0) {
  def newEnvVarsNodeProperty = new EnvironmentVariablesNodeProperty();
  globalNodeProperties.add(newEnvVarsNodeProperty)
  envVars = newEnvVarsNodeProperty.getEnvVars()
} else {
  envVars = envVarsNodePropertyList.get(0).getEnvVars()
}

envVars["JENKINS_INSTANCE"] = System.env.JENKINS_INSTANCE

Jenkins.instance.save()
