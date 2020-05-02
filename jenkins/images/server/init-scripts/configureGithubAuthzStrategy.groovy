import jenkins.model.Jenkins
import hudson.security.GlobalMatrixAuthorizationStrategy

def agentUser = System.env.GITHUB_AGENT_USER ?: 'jenkins-cicdenv'

def organization = System.env.GITHUB_ORGANIZATION ?: 'cicdenv'

def strategy = new GlobalMatrixAuthorizationStrategy()

/*
 Permission Categories:
   Overall | Credentials | Agent| Job | Run | View | SCM | Metrics | Lockable Resources | Scriptler
 NOTE: can be seen in ${JENKINS_HOME}/config.xml
*/
def overall     = "hudson.model.Hudson"
def credentials = "com.cloudbees.plugins.credentials.CredentialsProvider"
def agents      = "hudson.model.Computer"
def jobs        = "hudson.model.Item"
def runs        = "hudson.model.Run"
def views       = "hudson.model.View"
def scm         = "hudson.scm.SCM"
def metrics     = "jenkins.metrics.api.Metrics"
def locks       = "org.jenkins.plugins.lockableresources.LockableResourcesManager"
def scriptler   = "org.jenkinsci.plugins.scriptler.ScriptlerManagement"

def permissionsByPrincipals = [
    "fred-vogt": [
        (overall)     : 'Administer',
        (credentials) : 'Delete|ManageDomains',
        (scriptler)   : 'Configure|RunScripts',
    ],
    "${agentUser}": [
        (agents)      : 'Build|Configure|Connect|Create|Delete|Disconnect',
    ],
    "authenticated": [
        (overall)     : 'Read',
        (credentials) : 'Create|Update|View',
        (agents)      : 'Build|Configure|Connect|Create|Delete|Disconnect',
        (jobs)        : 'Build|Cancel|Configure|Create|Delete|Discover|Move|Read|ViewStatus|Workspace',
        (runs)        : 'Delete|Replay|Update',
        (views)       : 'Configure|Create|Delete|Read',
        (scm)         : 'Tag',
        (metrics)     : 'HealthCheck|ThreadDump|View',
        (locks)       : 'Reserve|Unlock',
    ],
    "anonymous": [
        (metrics)     : 'HealthCheck|ThreadDump|View',
    ],
]

permissionsByPrincipals.each { principals, permissionsByCategory ->
    principals.tokenize('|').each { principal -> 
        permissionsByCategory.each { category, permissions ->
            permissions.tokenize('|').each { permission ->
                strategy.add("${category}.${permission}:${principal}")
            }
        }
    }
}

Jenkins.instance.authorizationStrategy = strategy
Jenkins.instance.save()
