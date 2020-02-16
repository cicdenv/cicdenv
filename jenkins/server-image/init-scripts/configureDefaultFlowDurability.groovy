import jenkins.model.Jenkins

import org.jenkinsci.plugins.workflow.flow.GlobalDefaultFlowDurabilityLevel
import org.jenkinsci.plugins.workflow.flow.FlowDurabilityHint

def durabilityLevel = Jenkins.instance.getExtensionList(GlobalDefaultFlowDurabilityLevel.DescriptorImpl.class).get(0);
if (durabilityLevel.durabilityHint != FlowDurabilityHint.PERFORMANCE_OPTIMIZED) {
    println 'Configured global default flow durability hint: PERFORMANCE_OPTIMIZED'

    durabilityLevel.durabilityHint = FlowDurabilityHint.PERFORMANCE_OPTIMIZED;
}
