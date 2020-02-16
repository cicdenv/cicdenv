import jenkins.model.Jenkins

/*
  Disable submitting anonymous usage statistics to the Jenkins project.
*/

if (Jenkins.instance.isUsageStatisticsCollected()) {
    println 'Disabled submitting usage stats to Jenkins project.'

    Jenkins.instance.setNoUsageStatistics(true)
    Jenkins.instance.save()
}
