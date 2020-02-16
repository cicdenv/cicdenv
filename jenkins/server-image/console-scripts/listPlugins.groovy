import jenkins.model.Jenkins

Jenkins.instance.pluginManager.plugins.each { plugin ->
    println "${plugin.shortName}):${plugin.version}"
}
