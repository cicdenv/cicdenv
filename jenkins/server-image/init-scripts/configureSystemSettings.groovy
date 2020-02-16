import jenkins.model.Jenkins

import hudson.tasks.Shell
import hudson.markup.RawHtmlMarkupFormatter

def systemMessage = ''
if (systemMessage != Jenkins.instance.systemMessage) {
    println "Blanking system message."

    Jenkins.instance.systemMessage = systemMessage
    Jenkins.instance.save()
}

Shell.DescriptorImpl shellConfig = Jenkins.instance.getExtensionList(Shell.DescriptorImpl.class).get(0)
if ('/bin/bash' != shellConfig.shell ) {
    println "Setting system shell: /bin/bash"

    shellConfig.shell = '/bin/bash'
    shellConfig.save()
}

// Configures the markup formatter for build and job descriptions
if (Jenkins.instance.markupFormatter == null 
    || !(Jenkins.instance.markupFormatter instanceof RawHtmlMarkupFormatter)) {
    println "Setting markup formmater."

    Jenkins.instance.markupFormatter = new RawHtmlMarkupFormatter(true)
    Jenkins.instance.save()
}
