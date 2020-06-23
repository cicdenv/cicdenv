import com.cloudbees.plugins.credentials.CredentialsScope
import com.cloudbees.plugins.credentials.SystemCredentialsProvider
import com.cloudbees.plugins.credentials.domains.Domain

import hudson.util.Secret

import com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl

import com.amazonaws.services.secretsmanager.AWSSecretsManagerClientBuilder
import com.amazonaws.services.secretsmanager.AWSSecretsManager
import com.amazonaws.services.secretsmanager.model.GetSecretValueRequest
import com.amazonaws.services.secretsmanager.model.GetSecretValueResult

import groovy.json.JsonSlurper

/*
  A shared method used by other "setCredential" methods to safely create a
  credential in the global domain.
  */
def addCredential(String credentialsId, def credential) {
    
    Domain domain
    SystemCredentialsProvider systemCreds = SystemCredentialsProvider.getInstance()
    Map systemCredsMap = systemCreds.getDomainCredentialsMap()

    domain = (systemCredsMap.keySet() as List).find { it.getName() == null }

    boolean modifiedCreds = false
    if (!systemCredsMap[domain] || (systemCredsMap[domain].findAll {credentialsId.equals(it.id)}).size() < 1) {
        if (systemCredsMap[domain] && systemCredsMap[domain].size() > 0) {
            // Other credentials exist so should only append
            systemCredsMap[domain] << credential
        } else {
            systemCredsMap[domain] = [credential]
        }

        println "Adding credential: ${credentialsId}"
        modifiedCreds = true
    }

    // Save any modified credentials
    if (modifiedCreds) {
        systemCreds.setDomainCredentialsMap(systemCredsMap)
        systemCreds.save()
    }
}

/*
  Supports SSH username and private key (directly entered private key)
  credential provided by BasicSSHUserPrivateKey class.
  Example:
    [
        'credentialType': 'BasicSSHUserPrivateKey',
        'credentialsId': 'some-credential-id',
        'description': 'A description of this credential',
        'user': 'some user',
        'keyPasswd': 'secret phrase',
        'key': '''
<key>
        '''.trim()
    ]
  */
def setBasicSSHUserPrivateKey(Map settings) {
    String credentialsId = ((settings['credentialsId'])?:'').toString()
    String user = ((settings['user'])?:'').toString()
    String key = ((settings['key'])?:'').toString()
    String keyPasswd = ((settings['keyPasswd'])?:'').toString()
    String description = ((settings['description'])?:'').toString()

    addCredential(credentialsId,
                new BasicSSHUserPrivateKey(CredentialsScope.GLOBAL,
                                            credentialsd,
                                            user,
                                            new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(key),
                                            keyPasswd,
                                            description)
    )
}

/*
  Supports String credential provided by StringCredentialsImpl class.
  Example:
    [
        'credentialType': 'StringCredentialsImpl',
        'credentialsId': 'some-credential-id',
        'description': 'A description of this credential',
        'secret': 'super secret text'
    ]
  */
def setStringCredentialsImpl(Map settings) {
    String credentialsId = ((settings['credentialsId'])?:'').toString()
    String description = ((settings['description'])?:'').toString()
    String secret = ((settings['secret'])?:'').toString()

    addCredential(credentialsId,
                new StringCredentialsImpl(CredentialsScope.GLOBAL,
                                        credentialsId,
                                        description,
                                        Secret.fromString(secret))
    )
}

/*
  Supports username and password credential provided by
  UsernamePasswordCredentialsImpl class.
  Example:
    [
        'credentialType': 'UsernamePasswordCredentialsImpl',
        'credentialsId': 'some-credential-id',
        'description': 'A description of this credential',
        'user': 'some user',
        'password': 'secret phrase'
    ]
  */
def setUsernamePasswordCredentialsImpl(Map settings) {
    String credentialsId = ((settings['credentialsId'])?:'').toString()
    String user = ((settings['user'])?:'').toString()
    String password = ((settings['password'])?:'').toString()
    String description = ((settings['description'])?:'').toString()

    addCredential(credentialsId, 
                  new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL,
                                                        credentialsId,
                                                        description,
                                                        user,
                                                        password)
    )
}

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

credentials = [
    [
        'credentialType': 'UsernamePasswordCredentialsImpl',
        'credentialsId': 'github-jenkins-token',
        'description': 'cicdenv - Github user/token',
        'user': secretValue['access-user'],
        'password': secretValue['access-token'],
    ],
    [
        'credentialType': 'StringCredentialsImpl',
        'credentialsId': 'github-manage-webhooks-token',
        'description': 'cicdenv - Github webhooks token',
        'secret': secretValue['webhooks-token'],
    ],
]

// Iterate through credentials and add them to Jenkins
credentials.each { credential ->
    if ("set${(credential['credentialType'])?:'empty credential_type'}".toString() in this.metaClass.methods*.name.toSet()) {
        "set${credential['credentialType']}"(credential)
    }
}
