import jenkins.model.Jenkins
import hudson.security.SecurityRealm
import org.jenkinsci.plugins.GithubSecurityRealm

import com.amazonaws.regions.Regions
import com.amazonaws.services.secretsmanager.AWSSecretsManagerClientBuilder
import com.amazonaws.services.secretsmanager.AWSSecretsManager
import com.amazonaws.services.secretsmanager.model.GetSecretValueRequest
import com.amazonaws.services.secretsmanager.model.GetSecretValueResult

import groovy.json.JsonSlurper

/**
 Assumes management console UI JSON wrapped secrets manager secret
 */
def getSecret(String secretName) {
    AWSSecretsManager client = AWSSecretsManagerClientBuilder.defaultClient()

    GetSecretValueRequest request = new GetSecretValueRequest().withSecretId(secretName)
    GetSecretValueResult response = client.getSecretValue(request)

    String raw = response.secretString
    return new JsonSlurper().parseText(raw) // JSON string => Map
}

def secretValue = getSecret(System.env.GITHUB_SECRET_ARN)

String clientID = secretValue['client-id']
String clientSecret = secretValue['client-secret']

String oauthScopes = 'read:org,user:email'

String githubWebUri = 'https://github.com'
String githubApiUri = 'https://api.github.com'

SecurityRealm github_realm = new GithubSecurityRealm(githubWebUri, githubApiUri, clientID, clientSecret, oauthScopes)

if (!github_realm.equals(Jenkins.instance.getSecurityRealm())) {
    Jenkins.instance.setSecurityRealm(github_realm)
    Jenkins.instance.save()

    println "Configured OAuth::GithubSecurityRealm."
}
