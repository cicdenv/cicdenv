import jenkins.model.Jenkins

if (Jenkins.instance.slaveAgentPort != -1) {
    println 'Configured JNLP agent port: -1'

    Jenkins.instance.slaveAgentPort = -1
}
