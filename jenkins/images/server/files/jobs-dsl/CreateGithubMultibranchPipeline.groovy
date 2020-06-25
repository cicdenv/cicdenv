import jenkins.model.Jenkins

folder('github') {
    description('Folder containing helper jobs')
}

pipelineJob("github/create-multibranch-pipeline") {
    description('Creates multibranch pipeline jobs')
    definition {
        cps {
            script(new File(Jenkins.instance.rootDir, 'jobs-dsl/CreateGithubMultibranchPipeline.Jenkinsfile').text)
            sandbox()
        }
    }
}
