import jenkins.model.Jenkins

def agentPort = System.env.JENKINS_SLAVE_AGENT_PORT as int

if (Jenkins.instance.slaveAgentPort != agentPort) {
    println 'Configured JNLP agent port: ${agentPort}'

    Jenkins.instance.slaveAgentPort = agentPort
}
