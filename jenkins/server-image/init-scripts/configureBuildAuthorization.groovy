import jenkins.security.QueueItemAuthenticatorConfiguration
import org.jenkinsci.plugins.authorizeproject.GlobalQueueItemAuthenticator
import org.jenkinsci.plugins.authorizeproject.strategy.TriggeringUsersAuthorizationStrategy

void setTriggeredUsersAuthStrategy() {
    println 'Configuring system build auhorization strategy.'

    GlobalQueueItemAuthenticator auth = new GlobalQueueItemAuthenticator(
        new TriggeringUsersAuthorizationStrategy()
    )
    QueueItemAuthenticatorConfiguration.get().authenticators.add(auth)
}

if (QueueItemAuthenticatorConfiguration.get().authenticators.size() == 0) {
    setTriggeredUsersAuthStrategy()
} else {
    if (QueueItemAuthenticatorConfiguration.get().authenticators.size() == 1
        && !(QueueItemAuthenticatorConfiguration.get().authenticators[0].strategy 
             instanceof TriggeringUsersAuthorizationStrategy)) {
        setTriggeredUsersAuthStrategy()
    }
}
