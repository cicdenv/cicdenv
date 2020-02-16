import jenkins.model.Jenkins

import org.jenkinsci.plugins.github_branch_source.GitHubConfiguration
import org.jenkinsci.plugins.github_branch_source.Endpoint

boolean isEndpointsEqual(List<Endpoint> e1, List<Endpoint> e2) {
    e1.size() == e2.size() && !(
        false in [e1, e2].transpose().collect { a, b ->
            a.name == b.name && a.apiUri == b.apiUri
        }
    )
}

List endpoints = [new Endpoint('https://api.github.com', 'Public GitHub API')]
def globalSettings = Jenkins.instance.getExtensionList(GitHubConfiguration.class)[0]

if (!isEndpointsEqual(globalSettings.endpoints, endpoints)) {
    globalSettings.endpoints = endpoints

    println "Configured GitHub Branch Source Endpoint: ${endpoints[0].apiUri}"
}
