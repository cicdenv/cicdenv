import jenkins.model.Jenkins

import org.jenkinsci.plugins.scriptler.config.ScriptlerConfiguration
import org.jenkinsci.plugins.scriptler.config.Parameter
import org.jenkinsci.plugins.scriptler.config.Script

import org.jenkinsci.plugins.scriptsecurity.scripts.Language
import org.jenkinsci.plugins.scriptsecurity.scripts.languages.GroovyLanguage

import org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval

// Configuration Handle
def config = ScriptlerConfiguration.getConfiguration()
config.setDisbableRemoteCatalog(true)
config.setAllowRunScriptPermission(false)
config.setAllowRunScriptEdit(false)

// Purge Agent Script
def scriptName = 'purgeAgents.groovy'
Script purgeAgents = new Script(scriptName,                      // id
                                'Purge-Disconnected-Agents',     // name
                                'Remove aged out build agents',  // comment
                                false,                           // nonAdministerUsing
                                [] as Parameter[],               // parameters
                                false)                           // onlyMaster
purgeAgents.script = '''
import jenkins.model.Jenkins

Jenkins.instance.nodes.each { node ->
    if (node.getComputer().isOffline()) {
        println "Deleting ${node.name}"

        node.getComputer().doDoDelete()
    }
}
'''
config.addOrReplace(purgeAgents)
config.save()

// Approve it
def scriptApproval = ScriptApproval.get()
scriptApproval.preapprove(purgeAgents.script, Jenkins.instance.getExtensionList(Language.class).get(GroovyLanguage.class))
scriptApproval.save()

// Persist to disk
File scriptlerHomeDirectory = new File(Jenkins.instance.getRootDir(), "scriptler")
File scriptsDirectory = new File(scriptlerHomeDirectory, "scripts")
File scriptFile = new File(scriptsDirectory, scriptName)
println "Script File: ${scriptFile}"
Writer writer = new FileWriter(scriptFile)
try {
    writer.write(purgeAgents.script)
} finally {
    writer.close()
}
println 'Done.'
