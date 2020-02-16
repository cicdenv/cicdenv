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
# - Agent JNLP $TUNNELING_URL 
#

AGENT_NAME=${AGENT_NAME:-$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)}
EXECUTORS=${EXECUTORS:-1}
CLI_JAR=${CLI_JAR:-/usr/share/jenkins/jenkins-cli.jar}


export AWS_DEFAULT_REGION=$(curl -m5 -sS http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')
AGENT_AUTH=$(aws secretsmanager get-secret-value                   \
                 --secret-id "${AGENT_SECRET_ARN:-jenkins-agent}"  \
             | jq -r '.SecretString'                               \
             | jq -r '.["agent-auth"]')

jenkins_cli() {
    java '-Djava.util.logging.SimpleFormatter.format=%1$tF %1$tT %4$-7s %5$s%6$s%n'  \
        -jar "$CLI_JAR" \
        -s "$SERVER_URL" \
        -logger FINE \
        -auth "$AGENT_AUTH" \
        "$@"
}

# Delete Jenkins node for this agent on exit
trap 'jenkins_cli delete-node "$AGENT_NAME" || true; ' SIGTERM SIGINT SIGHUP

# Create node for this agent in Jenkins unless it already exists
set +e
jenkins_cli get-node "$AGENT_NAME" || {
    read -r -d '' CONFIG <<-EOF
<slave>
    <remoteFS>$HOME</remoteFS>
    <numExecutors>$EXECUTORS</numExecutors>
    <launcher class="hudson.slaves.JNLPLauncher">
        <tunnel>${TUNNELING_URL}</tunnel>
        <workDirSettings>
            <disabled>false</disabled>
            <internalDir>remoting</internalDir>
            <failIfWorkDirIsMissing>false</failIfWorkDirIsMissing>
        </workDirSettings>
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
-Djava.io.tmpdir=/tmp  \
\
-Dhttp.proxyHost=${PROXY_HOST-}           \
-Dhttp.proxyPort=${PROXY_PORT-}           \
-Dhttps.proxyHost=${PROXY_HOST-}          \
-Dhttps.proxyPort=${PROXY_PORT-}          \
-Dhttp.nonProxyHosts=${NON_PROXY_HOSTS-}"

SERVER_JNLP_URL=${SERVER_URL}/computer/${AGENT_NAME}/slave-agent.jnlp

REMOTING_JAR=/usr/share/jenkins/slave.jar

# Import default SSH key (optional - for local testing)
if [[ ! -f "${HOME}/.ssh/id_rsa" ]]; then
    cp /tmp/.ssh/id_rsa "${HOME}/.ssh/id_rsa"
    chmod 600 "${HOME}/.ssh/id_rsa"
fi

java ${JAVA_OPTS}                      \
    -jar "${REMOTING_JAR}"             \
    -workDir "${HOME}"                 \
    -jar-cache "${JAR_CACHE_DIR}"      \
    -jnlpCredentials "${AGENT_AUTH}"   \
    -jnlpUrl "${SERVER_JNLP_URL}"      \
    &
wait $!
exit $?
