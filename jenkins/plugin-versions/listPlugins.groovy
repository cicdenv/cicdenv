#!/usr/bin/env groovy

def plugins = jenkins.model.Jenkins.instance.getPluginManager().getPlugins()
new ArrayList(plugins).sort().each { plugin ->
    println "${plugin.getShortName()}: ${plugin.getVersion()}"
}
