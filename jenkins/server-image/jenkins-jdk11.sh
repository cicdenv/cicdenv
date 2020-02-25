#! /bin/bash -e

JENKINS_WORKSPACE_LOCATION='/var/jenkins_home/workspace/${ITEM_FULL_NAME}'
JENKINS_BUILDS_LOCATION='/var/jenkins_home/builds/${ITEM_FULL_NAME}'

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
-Xlog:gc*:file=/var/jenkins_home/gc.log::filecount=5,filesize=20m \
\
-Xms${JVM_OPT_XMS-1024m}  \
-Xmx${JVM_OPT_XMX-1024m}  \
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
-Dhudson.DNSMultiCast.disabled=true                                     \
-Dhudson.model.UsageStatistics.disabled=true                            \
-Djenkins.model.Jenkins.logStartupPerformance=true                      \
-Djenkins.model.StandardArtifactManager.disableTrafficCompression=true  \
-Dhudson.model.UpdateCenter.never=true                                  \
-Djenkins.CLI.disabled=true                                             \
-Dhudson.consoleTailKB=1024                                             \
-Djenkins.install.runSetupWizard=false                                  \
-Djenkins.InitReactorRunner.concurrency=64                              \
-Dpermissive-script-security.enabled=no_security                        \
-Dhudson.model.DirectoryBrowserSupport.CSP=                             \
-Dhudson.footerURL=${FOOTER_URL}                                        \
-Djenkins.model.Jenkins.workspacesDir=${JENKINS_WORKSPACE_LOCATION}     \
-Djenkins.model.Jenkins.buildsDir=${JENKINS_BUILDS_LOCATION}            \
-Dhudson.InitReactorRunner.concurrency=$(($(nproc) * 8))                \
${EXTRA_JAVA_OPTS-}"

JENKINS_OPTS="${JENKINS_OPTS-\
--httpPort=${HTTP_PORT-8080} \
--httpsPort=${HTTPS_PORT-8443} \
--http2Port=${HTTP2_PORT-9443} \
--accessLoggerClassName=winstone.accesslog.SimpleAccessLogger  \
--simpleAccessLogger.format=combined                           \
--simpleAccessLogger.file=/var/jenkins_home/logs/access.log    \
--extraLibFolder=/var/jenkins_home/extraLibs                   \
--httpsPrivateKey=/var/jenkins_home/tls/server-rsa.pem         \
--httpsCertificate=/var/jenkins_home/tls/server-cert.pem}      \
${EXTRA_JENKINS_OPTS-}"

echo "JENKINS_HOME               = ${JENKINS_HOME}"            
echo "JENKINS_WORKSPACE_LOCATION = ${JENKINS_WORKSPACE_LOCATION}"
echo "JENKINS_BUILDS_LOCATION    = ${JENKINS_BUILDS_LOCATION}"
echo "JAVA_OPTS                  = ${JAVA_OPTS}"
echo "JENKINS_OPTS               = ${JENKINS_OPTS}"
echo "EXTRA_JENKINS_OPTS         = ${EXTRA_JENKINS_OPTS}"     
echo "SERVER_URL                 = ${SERVER_URL}"
echo "FOOTER_URL                 = ${FOOTER_URL}"
echo "HTTP_PORT   http/1.1       = ${HTTP_PORT-8080}"
echo "HTTPS_PORT  https/1.1      = ${HTTPS_PORT-8443}"
echo "HTTP2_PORT  http/2         = ${HTTP2_PORT-9443}"

# Upstream: https://github.com/jenkinsci/docker/commit/0832831fa201e6c66e7f1a7f2da7aa73403a2671

: "${JENKINS_WAR:="/usr/share/jenkins/jenkins.war"}"
: "${JENKINS_HOME:="/var/jenkins_home"}"
: "${COPY_REFERENCE_FILE_LOG:="${JENKINS_HOME}/copy_reference_file.log"}"
: "${REF:="/usr/share/jenkins/ref"}"
touch "${COPY_REFERENCE_FILE_LOG}" || { echo "Can not write to ${COPY_REFERENCE_FILE_LOG}. Wrong volume permissions?"; exit 1; }
echo "--- Copying files at $(date)" >> "$COPY_REFERENCE_FILE_LOG"
find "${REF}" \( -type f -o -type l \) -exec bash -c '. /usr/local/bin/jenkins-support; for arg; do copy_reference_file "$arg"; done' _ {} +

# if `docker run` first argument start with `--` the user is passing jenkins launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then

  # read JAVA_OPTS and JENKINS_OPTS into arrays to avoid need for eval (and associated vulnerabilities)
  java_opts_array=()
  while IFS= read -r -d '' item; do
    java_opts_array+=( "$item" )
  done < <([[ $JAVA_OPTS ]] && xargs printf '%s\0' <<<"$JAVA_OPTS")

  if [[ "$DEBUG" ]] ; then
    java_opts_array+=( \
      '-Xdebug' \
      '-Xrunjdwp:server=y,transport=dt_socket,address=*:8000,suspend=y' \
    )
  fi

  jenkins_opts_array=( )
  while IFS= read -r -d '' item; do
    jenkins_opts_array+=( "$item" )
  done < <([[ $JENKINS_OPTS ]] && xargs printf '%s\0' <<<"$JENKINS_OPTS")

  set -x
  exec java                            \
          -Duser.home="$JENKINS_HOME"  \
          "${java_opts_array[@]}"      \
          -cp "${JENKINS_WAR}"         \
          Main                         \
          "${jenkins_opts_array[@]}"   \
          "$@"
fi

# As argument is not jenkins, assume user want to run his own process, for example a `bash` shell to explore this image
exec "$@"
