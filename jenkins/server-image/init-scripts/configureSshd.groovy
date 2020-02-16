import jenkins.model.Jenkins

def desc = Jenkins.instance.getDescriptor("org.jenkinsci.main.modules.sshd.SSHD")

def currentPort = desc.getActualPort()
def expectedPort = 16022

if (currentPort != expectedPort) {
    desc.setPort(expectedPort)

    println "Configured org.jenkinsci.main.modules.sshd.SSHD::port => ${expectedPort}"
}
