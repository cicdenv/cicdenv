import jenkins.model.Jenkins

import com.cloudbees.plugins.credentials.CredentialsProvider

def stringType = org.jenkinsci.plugins.plaincredentials.StringCredentials.class
for (cred in CredentialsProvider.lookupCredentials(stringType, Jenkins.instance, null, null)) {
  println("ID: ${cred.id}")
  println("Description: ${cred.description}")
  println("Secret: ${cred.secret}")
}

println()

def usernameType = com.cloudbees.plugins.credentials.common.StandardUsernameCredentials.class
for (cred in CredentialsProvider.lookupCredentials(usernameType, Jenkins.instance, null, null)) {
  println("ID: ${cred.id}")
  println("Description: ${cred.description}")
  println("UserName: ${cred.username}")
  println("Password: ${cred.password}")
}
