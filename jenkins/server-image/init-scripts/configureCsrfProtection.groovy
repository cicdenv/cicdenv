import jenkins.model.Jenkins
import hudson.security.csrf.DefaultCrumbIssuer

//
// https://wiki.jenkins.io/display/JENKINS/CSRF+Protection
//

// Configures CSRF protection in global security settings.
if (Jenkins.instance.getCrumbIssuer() == null) {
    Jenkins.instance.setCrumbIssuer(new DefaultCrumbIssuer(true))
    Jenkins.instance.save()

    println 'CSRF Protection configuration changed to: (Enabled).'
}
