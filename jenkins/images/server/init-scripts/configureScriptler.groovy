import jenkins.model.Jenkins

import org.jenkinsci.plugins.scriptler.config.ScriptlerConfiguration
import org.jenkinsci.plugins.scriptler.config.Parameter
import org.jenkinsci.plugins.scriptler.config.Script

import org.jenkinsci.plugins.scriptsecurity.scripts.Language
import org.jenkinsci.plugins.scriptsecurity.scripts.languages.GroovyLanguage

import org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval

import static groovy.io.FileType.FILES

// Configuration Handle
def config = ScriptlerConfiguration.getConfiguration()
config.setDisbableRemoteCatalog(true)
config.setAllowRunScriptPermission(false)
config.setAllowRunScriptEdit(false)

// Load scripts in $JENKINS_HOME/scriptler/*.groovy
def scriptlerDir = new File(Jenkins.instance.root, 'scriptler');
scriptlerDir.eachFileMatch(FILES, ~/.*\.groovy/) { file ->
    String scriptId    = file.name
    String displayName = file.name.split('\\.groovy')[0].replaceAll(/([a-z])([A-Z])/, '$1-$2').toLowerCase()
    String comment     = file.name.split('\\.groovy')[0].replaceAll(/([a-z])([A-Z])/, '$1 $2').capitalize()

    Script s = new Script(scriptId,           // id
                          displayName,        // name
                          comment,            // comment
                          false,              // nonAdministerUsing
                          [] as Parameter[],  // parameters
                          false)              // onlyMaster
    s.script = file.text
    config.addOrReplace(s)

    // Approve it
    def scriptApproval = ScriptApproval.get()
    scriptApproval.preapprove(s.script, Jenkins.instance.getExtensionList(Language.class).get(GroovyLanguage.class))
    scriptApproval.save()
}
config.save()
