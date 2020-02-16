import jenkins.model.Jenkins

def desc = Jenkins.instance.getDescriptor("hudson.plugins.git.GitSCM")

// Should match ~/.gitconfig
def name = 'cicdenv'
def email = 'ci+jenkins@cicdenv.com'
 
if (desc.globalConfigName != name || desc.globalConfigEmail != email) {
    println 'GitSCM configuration updated.'

    desc.globalConfigName = name
    desc.globalConfigEmail = email
    desc.save()
}
