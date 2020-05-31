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

if [[ -z "$AGENT_NAME" ]]; then  # Assume EC2 instance with IMDSv2
    IMDSv2_TOKEN=$(curl -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 30" -sL "http://169.254.169.254/latest/api/token")
    AGENT_NAME=$(curl -H "X-aws-ec2-metadata-token:$IMDSv2_TOKEN" -sL http://169.254.169.254/latest/meta-data/local-ipv4)
fi
EXECUTORS=${EXECUTORS:-1}
CLI_JAR=${CLI_JAR:-/usr/share/jenkins/jenkins-cli.jar}

AGENT_AUTH=$(aws secretsmanager get-secret-value                   \
                 --secret-id "${AGENT_SECRET_ARN:-jenkins-agent}"  \
             | jq -r '.SecretString'                               \
             | jq -r '.["agent-auth"]')

jenkins_cli() {
    java ${EXTRA_CLIENT_OPTS-}  \
        -jar "$CLI_JAR"         \
        -s "${SERVER_URL}"      \
        -webSocket              \
        -logger FINE            \
        -auth "$AGENT_AUTH"     \
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
set -e

# Need agent secret-key to connect w/websockets
SERVER_JNLP_URL=${SERVER_URL}/computer/${AGENT_NAME}/slave-agent.jnlp
CSRF_CRUMB=$(curl -sk -u "${AGENT_AUTH}" "${SERVER_URL}"'/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')
curl -skL                 \
    -u "${AGENT_AUTH}"    \
    -H "${CSRF_CRUMB}"    \
    "${SERVER_JNLP_URL}"  \
> "/tmp/slave-agent.jnlp"
cat "/tmp/slave-agent.jnlp"
SECRET_KEY=$(sed -E 's!.*<argument>\s*([a-z0-9]{64})\s*</argument>.*!\1!' < "/tmp/slave-agent.jnlp")
echo "$SECRET_KEY" > connect-secret

JAVA_OPTS="\
-XX:+AlwaysPreTouch               \
-XX:-PrintCommandLineFlags        \
\
-XX:NumberOfGCLogFiles=5          \
-XX:+UseGCLogFileRotation         \
-XX:GCLogFileSize=20m             \
-XX:+PrintGC                      \
-XX:+PrintGCDateStamps            \
-XX:+PrintGCDetails               \
-XX:+PrintHeapAtGC                \
-XX:+PrintGCCause                 \
-XX:+PrintTenuringDistribution    \
-XX:+PrintReferenceGC             \
-XX:+PrintAdaptiveSizePolicy      \
\
-XX:+UseG1GC                      \
-XX:+ExplicitGCInvokesConcurrent  \
-XX:+ParallelRefProcEnabled       \
-XX:+UseStringDeduplication       \
-XX:+UnlockExperimentalVMOptions  \
-XX:G1NewSizePercent=20           \
-XX:+UnlockDiagnosticVMOptions    \
-XX:G1SummarizeRSetStatsPeriod=1  \
-Xloggc:/var/lib/jenkins/gc.log  \
\
-Xms${JVM_OPT_XMS-1024m}  \
-Xmx${JVM_OPT_XMX-1024m}  \
-XX:MetaspaceSize=512M    \
\
-Djava.io.tmpdir=/tmp \
\
-Djava.net.preferIPv4Stack=true           \
-Dhttp.proxyHost=${PROXY_HOST-}           \
-Dhttp.proxyPort=${PROXY_PORT-}           \
-Dhttps.proxyHost=${PROXY_HOST-}          \
-Dhttps.proxyPort=${PROXY_PORT-}          \
-Dhttp.nonProxyHosts=${NON_PROXY_HOSTS-}  \
\
${EXTRA_AGENT_OPTS-}"

AGENT_JAR=/usr/share/jenkins/agent.jar

java ${JAVA_OPTS}                  \
    -jar "${AGENT_JAR}"            \
    -workDir "${HOME}"             \
    -jar-cache "${JAR_CACHE_DIR}"  \
    -jnlpUrl "${SERVER_JNLP_URL}"  \
    -secret @connect-secret        \
    &

wait $!
exit $?
