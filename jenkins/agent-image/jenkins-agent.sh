#!/bin/bash -eux

#
# Agent Entry Point
#
# Should remain runnable "outside" of the docker image
# to test the agent resgistration via CLI.
#

#
# We connect to the jenkins server in two ways:
# - REST API $SERVER_URL
# - Agent WebSocket $SERVER_URL 
#

AGENT_NAME=${AGENT_NAME:-$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)}
EXECUTORS=${EXECUTORS:-1}
CLI_JAR=${CLI_JAR:-/usr/share/jenkins/jenkins-cli.jar}

AGENT_AUTH=$(aws secretsmanager get-secret-value                   \
                 --secret-id "${AGENT_SECRET_ARN:-jenkins-agent}"  \
             | jq -r '.SecretString'                               \
             | jq -r '.["agent-auth"]')

_CLI_JAVA_OPTS= # "-Djava.util.logging.config.file=/var/lib/jenkins/logging.properties"
_CLI_JAVA_OPTS="${_CLI_JAVA_OPTS} -Djavax.net.ssl.trustStore=/var/lib/jenkins/truststore.jks"
_CLI_JAVA_OPTS="${_CLI_JAVA_OPTS} -Djavax.net.ssl.trustStorePassword=jenkins"
jenkins_cli() {
    java $_CLI_JAVA_OPTS     \
        -jar "$CLI_JAR"      \
        -s "$SERVER_URL"     \
        -logger FINE         \
        -auth "$AGENT_AUTH"  \
        "$@"
}

# Delete Jenkins node for this agent on exit
trap 'jenkins_cli delete-node "$AGENT_NAME" || true; ' SIGTERM SIGINT SIGHUP

# Create node for this agent in Jenkins unless it already exists
set +e
jenkins_cli get-node "$AGENT_NAME" || {
    read -r -d '' CONFIG <<-EOF
<slave>
    <name>${AGENT_NAME}</name>
    <description>Self registering agent</description>
    <remoteFS>$HOME</remoteFS>
    <numExecutors>$EXECUTORS</numExecutors>
    <launcher class="hudson.slaves.JNLPLauncher">
        <workDirSettings>
            <disabled>false</disabled>
            <internalDir>remoting</internalDir>
            <failIfWorkDirIsMissing>false</failIfWorkDirIsMissing>
        </workDirSettings>
        <webSocket>true</webSocket>
    </launcher>
</slave>
EOF

    set -e

    jenkins_cli create-node "$AGENT_NAME" <<< "$CONFIG" || sleep 5
}

JAVA_OPTS="\
-XX:+AlwaysPreTouch               \
-XX:-PrintCommandLineFlags        \
\
-XX:+UseG1GC                      \
-XX:+ExplicitGCInvokesConcurrent  \
-XX:+ParallelRefProcEnabled       \
-XX:+UseStringDeduplication       \
-XX:+UnlockExperimentalVMOptions  \
-XX:+UnlockDiagnosticVMOptions    \
-Xlog:gc*:file=${HOME}/gc.log::filecount=5,filesize=20m  \
\
-Xms${JVM_OPT_XMS-1024m}  \
-Xmx${JVM_OPT_XMX-1024m}  \
\
-Djava.io.tmpdir=/tmp \
\
-Dhttp.proxyHost=${PROXY_HOST-}           \
-Dhttp.proxyPort=${PROXY_PORT-}           \
-Dhttps.proxyHost=${PROXY_HOST-}          \
-Dhttps.proxyPort=${PROXY_PORT-}          \
-Dhttp.nonProxyHosts=${NON_PROXY_HOSTS-}  \
\
-Djavax.net.ssl.trustStore=/var/lib/jenkins/truststore.jks \
-Djavax.net.ssl.trustStorePassword=jenkins"

# remoting.jar
AGENT_JAR=/usr/share/jenkins/agent.jar
MAIN_CLASS=hudson.remoting.jnlp.Main

java ${JAVA_OPTS}                      \
    -cp "${AGENT_JAR}" "$MAIN_CLASS"   \
    -workDir "${HOME}"                 \
    -jar-cache "${JAR_CACHE_DIR}"      \
    -url "${SERVER_URL}"               \
    -webSocket                         \
    -noreconnect                       \
    -headless                          \
    "$AGENT_AUTH"                      \
    "$AGENT_NAME"                      \
    &
wait $!
exit $?
