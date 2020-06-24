import jenkins.model.Jenkins

import javaposse.jobdsl.dsl.DslScriptLoader
import javaposse.jobdsl.plugin.JenkinsJobManagement

import static groovy.io.FileType.FILES

new File(Jenkins.instance.rootDir, 'jobs-dsl').eachFileMatch(FILES, ~/.*\.groovy/) { file ->
    def jobManagement = new JenkinsJobManagement(System.out, [:], Jenkins.instance.rootDir)
    new DslScriptLoader(jobManagement).runScript(file.text)
}
