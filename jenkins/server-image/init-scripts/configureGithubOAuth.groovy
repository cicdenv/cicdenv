import jenkins.model.Jenkins
import hudson.security.SecurityRealm
import org.jenkinsci.plugins.GithubSecurityRealm

String githubWebUri = 'https://github.com'
String githubApiUri = 'https://api.github.com'

String clientID = System.env.GITHUB_OAUTH_CLIENT_ID
String clientSecret = System.env.GITHUB_OAUTH_CLIENT_SECRET

String oauthScopes = 'read:org,user:email'

SecurityRealm github_realm = new GithubSecurityRealm(githubWebUri, githubApiUri, clientID, clientSecret, oauthScopes)

if (!github_realm.equals(Jenkins.instance.getSecurityRealm())) {
    Jenkins.instance.setSecurityRealm(github_realm)
    Jenkins.instance.save()

    println "Configured OAuth::GithubSecurityRealm."
}
