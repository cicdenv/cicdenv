import jenkins.model.Jenkins

def executors = 0

if (Jenkins.instance.numExecutors != executors) {
    println 'Configured server number of executors: ${executors}'

    Jenkins.instance.numExecutors = executors
}
