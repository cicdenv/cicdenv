def jobName
def jobDescription
def OriginPullRequestDiscoveryTraits = [
    'HEAD':   1,
    'MERGED': 2,
    'BOTH':   3,
]
def BranchDiscoveryTraits = [
  'Exclude branches that are also filed as PRs': 1,
  'Only branches that are also filed as PRs':    2,
  'All branches':                                3,
]

def uuid

def repoDescription(params) {
    withCredentials([usernamePassword(credentialsId: 'github-jenkins-token', 
                                      usernameVariable: 'username', 
                                      passwordVariable: 'GITHUB_ACCESS_TOKEN')]) {
        // -sSfL
        def response = readJSON(text: sh(script: """
curl --silent --show-error --fail                           \
     --request POST 'https://api.github.com/graphql'        \
     --header 'Authorization: token ${GITHUB_ACCESS_TOKEN}' \
     --data-binary @- <<'EOF'
{
  "variables": {
    "parent": "${params.parent}",
    "repo":   "${params.repo}"
   },
  "query": "query (\$parent:String!, \$repo:String!) { ${params.parentType}(login: \$parent) { repository(name: \$repo) { description } } }"
}
EOF
""", returnStdout: true))
        return response["data"][params.parentType]["repository"]?.description ?: ''
    }
}

pipeline {
    parameters {
        string(name: 'parent',  description: '(Required) - github user|organization')
        choice(name: 'parentType', choices: ['organization', 'user'], 
            description: 'Github top-level parent (organiztion|user).')
        string(name: 'repo', description: '(Required) - github repository')
        string(name: 'name',     defaultValue: '',            description: '(Optional) - defaults to {repo} name')
        string(name: 'script',   defaultValue: 'Jenkinsfile', description: 'Relative path to Jenkins pipeline definition')
        string(name: 'branches', defaultValue: 'master',      description: 'List of patterns. Example: "master release*"')
        choice(name: 'checkoutStrategy', choices: ['HEAD', 'MERGED', 'BOTH'], 
        	description: '(Pull Requests) HEAD: Source branch, MERGED: merged with target branch, BOTH: separate jobs.')
    }   
    agent {
        docker {
            image 'buildpack-deps:sid-scm'
        }
    }
    stages {
        stage('multibranch Pipeline Job') {
            when { 
                allOf {
                    expression { params.parent != null }
                    expression { params.repo   != null }
                }
            }
            steps {
                script {
                    if (!params.name) {
                    	jobName = params.repo
                    }
                    jobDescription = repoDescription(params)

                    uuid = UUID.nameUUIDFromBytes("${params.parent}/${jobName}/${params.script}".getBytes()).toString()
                }
                jobDsl(sandbox: true, scriptText: """
folder("${params.parent}") {
    description('Folder containing "https://github/${params.parent}" multibranch pipeline jobs')
}
multibranchPipelineJob("${params.parent}/${jobName}") {
    description("${jobDescription}")

    configure { job ->
        job / sources / 'data' / 'jenkins.branch.BranchSource' << {
            delegate.source(class: 'org.jenkinsci.plugins.github_branch_source.GitHubSCMSource') {
                id("${uuid}")
                credentialsId('github-jenkins-token')
                repoOwner("${params.parent}")
                repository("${params.repo}")
                repositoryUrl("https://github.com/${params.parent}/${params.repo}.git")
                traits {
                    'org.jenkinsci.plugins.github__branch__source.BranchDiscoveryTrait' {
                        strategyId(${OriginPullRequestDiscoveryTraits['Exclude branches that are also filed as PRs']})
                    }
                    'org.jenkinsci.plugins.github__branch__source.OriginPullRequestDiscoveryTrait' {
                        strategyId(${OriginPullRequestDiscoveryTraits[params.checkoutStrategy]})
                    }
                    'jenkins.scm.impl.trait.WildcardSCMHeadFilterTrait' {
                        includes("${params.branches}")
                        excludes("")
                    }
                    'com.adobe.jenkins.disable__github__multibranch__status.DisableStatusUpdateTrait'()
                }
            }
        }
        job / factory(class: 'org.jenkinsci.plugins.workflow.multibranch.WorkflowBranchProjectFactory') {
            delegate.owner(class: 'org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject', reference: '../..')
            delegate.scriptPath("${params.script}")
        }
    }
}
""")
            }
        }
        stage('scan') {
            when { 
                allOf {
                    expression { params.parent != null }
                    expression { params.repo   != null }
                }
            }
            steps {
                build job: "${params.parent}/${jobName}", wait: false
            }
        }
    }
}
