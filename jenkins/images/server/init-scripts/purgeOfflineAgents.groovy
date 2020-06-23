import jenkins.model.Jenkins

import com.amazonaws.services.ec2.model.Filter
import com.amazonaws.services.ec2.AmazonEC2ClientBuilder
import com.amazonaws.services.ec2.AmazonEC2Client
import com.amazonaws.services.ec2.model.DescribeInstancesRequest
import com.amazonaws.services.ec2.model.DescribeInstancesResult

AmazonEC2Client client = AmazonEC2ClientBuilder.defaultClient()

def deleteNode(def node) {
    println "Deleting: ${node.name}"
    node.getComputer().doDoDelete()
}

Jenkins.instance.nodes.each { node ->
    if (node.getComputer().isOffline()) {
        println "Offline: ${node.name}"

        m = node.name =~ /.*(?<id>i-[0-9a-zA-Z]+)-.*/
        if (m.matches()) {
            String instanceId = m.group('id')
    
            DescribeInstancesRequest request \
                = new DescribeInstancesRequest()
                    .withFilters(new Filter("instance-id", Collections.singletonList(instanceId)))
            DescribeInstancesResult response = client.describeInstances(request)
            if (!response.reservations) {
                deleteNode(node)
            } else if (response.reservations[0].instances[0].state.name == "terminated") {
                deleteNode(node)
            }
        }
    }
}
