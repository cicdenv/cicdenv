import jenkins.security.s2m.AdminWhitelistRule
import jenkins.model.Jenkins

//
// https://wiki.jenkins.io/display/JENKINS/Slave+To+Master+Access+Control
// <jenkins>/configureSecurity and check "Enable Slave → Master Access Control"
//

// Turn off master kill switch
AdminWhitelistRule awlRuleClass = Jenkins.instance.getInjector().getInstance(AdminWhitelistRule.class)
if (awlRuleClass.masterKillSwitch) {
	println "Disabling agent to server kill switch."
    awlRuleClass.masterKillSwitch = false
}
