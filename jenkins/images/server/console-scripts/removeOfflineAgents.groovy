import jenkins.model.Jenkins

Jenkins.instance.nodes.each { node ->
    if (node.getComputer().isOffline()) {
        println "Deleting ${node.name}"

        node.getComputer().doDoDelete()
    }
}
