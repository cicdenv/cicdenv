import jenkins.model.Jenkins
import jenkins.plugins.git.GitSCMSource
import jenkins.plugins.git.traits.BranchDiscoveryTrait
import org.jenkinsci.plugins.workflow.libs.GlobalLibraries
import org.jenkinsci.plugins.workflow.libs.LibraryConfiguration
import org.jenkinsci.plugins.workflow.libs.SCMSourceRetriever
import net.sf.json.JSONObject

/*
  Configure pipeline shared libraries in the global Jenkins configuration.

  This will safely compare configured libraries and only overwrite the global 
  shared library config if changes have been made.
*/

String specialInstance = 'test'  // 'test' instance is special - for testing shared library PRs
String jenkinsInstance = System.env.JENKINS_INSTANCE

def organization = System.env.GITHUB_ORGANIZATION ?: 'vogtech'

globalPipelineLibraries = [
    'jenkins-global-library': [
        'defaultVersion': 'master',
        'implicit': jenkinsInstance == specialInstance ? false : true,
        'allowVersionOverride': jenkinsInstance == specialInstance ? true : false,
        'includeInChangesets': false,
        'scm': [
            'remote': "https://github.com/${organization}/jenkins-global-library.git".toString(),
            'credentialsId': 'github-jenkins-token',
        ],
    ]
] as JSONObject

/*
  Function to compare if the two global shared libraries are equal.
 */
boolean libraryEquals(List lib1, List lib2) {
    lib1.size() == lib2.size() && !(false in [lib1, lib2].transpose().collect { l1, l2 ->
            def s1 = l1.retriever.scm
            def s2 = l2.retriever.scm

            l1.retriever.class == l2.retriever.class &&
            l1.name == l2.name &&
            l1.defaultVersion == l2.defaultVersion &&
            l1.implicit == l2.implicit &&
            l1.allowVersionOverride == l2.allowVersionOverride &&
            l1.includeInChangesets == l2.includeInChangesets &&
            s1.remote == s2.remote &&
            s1.credentialsId == s2.credentialsId &&
            s1.traits.size() == s2.traits.size() && !(false in [s1.traits, s2.traits].transpose().collect { t1, t2 ->
                t1.class == t2.class
            })
        }
    )
}

List libraries = [] as ArrayList
globalPipelineLibraries.each { name, config ->
    if (name 
    	&& config && config in Map 
    	&& 'scm' in config  && config['scm'] in Map && 'remote' in config['scm']  && config['scm'].optString('remote')) {

        def scm = new GitSCMSource(config['scm'].optString('remote'))
        scm.credentialsId = config['scm'].optString('credentialsId')
        scm.traits = [new BranchDiscoveryTrait()]

        def retriever = new SCMSourceRetriever(scm)
        def library = new LibraryConfiguration(name, retriever)
        
        library.defaultVersion = config.optString('defaultVersion')
        library.implicit = config.optBoolean('implicit', false)
        library.allowVersionOverride = config.optBoolean('allowVersionOverride', true)
        library.includeInChangesets = config.optBoolean('includeInChangesets', true)
        libraries << library
    }
}

def globalSettings = Jenkins.instance.getExtensionList(GlobalLibraries.class)[0]

if (libraries && !libraryEquals(globalSettings.libraries, libraries)) {
    globalSettings.libraries = libraries
    globalSettings.save()
    
    println 'Configured Global Implicitly Shared Pipeline Libraries:\n    ' + globalSettings.libraries.collect { it.name }.join('\n    ')
}
