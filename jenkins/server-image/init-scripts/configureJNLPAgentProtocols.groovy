import jenkins.model.Jenkins

/*
   Disable all JNLP protocols except for JNLP4.  

   JNLP4 uses standard TLS.
*/

Set<String> agentProtocolsList = ['JNLP4-connect', 'Ping']
if (!Jenkins.instance.agentProtocols.equals(agentProtocolsList)) {
    println "Configured agent protocols updated.  New protocols list: ${agentProtocolsList}"

    Jenkins.instance.agentProtocols = agentProtocolsList
    Jenkins.instance.save()
}
