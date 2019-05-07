#!/bin/bash
set -euo pipefail

# Set recommended umask of "u=,g=w,o=rwx" (0027)
umask 0027

# Setup Catalina Opts
: ${CATALINA_CONNECTOR_PROXYNAME:=}
: ${CATALINA_CONNECTOR_PROXYPORT:=}
: ${CATALINA_CONNECTOR_SCHEME:=http}
: ${CATALINA_CONNECTOR_SECURE:=false}

: ${CATALINA_OPTS:=}

: ${JAVA_OPTS:=}

: ${ELASTICSEARCH_ENABLED:=true}
: ${APPLICATION_MODE:=}

CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorProxyName=${CATALINA_CONNECTOR_PROXYNAME}"
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorProxyPort=${CATALINA_CONNECTOR_PROXYPORT}"
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorScheme=${CATALINA_CONNECTOR_SCHEME}"
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorSecure=${CATALINA_CONNECTOR_SECURE}"

JAVA_OPTS="${JAVA_OPTS} ${CATALINA_OPTS}"

ARGS="$@"

# configure clustering if properties file was specified
if [ -n "${JIRA_CLUSTER_CONFIG}" ]; then
    NEW_NODE_ID=$(uuidgen)
    echo "jira.node.id=${NEW_NODE_ID}" >> "${JIRA_CLUSTER_CONFIG}"
    echo "jira.shared.home=${JIRA_SHARED_HOME}" >> "${JIRA_CLUSTER_CONFIG}"
    echo "${JIRA_CLUSTER_CONFIG}:"
    cat "${JIRA_CLUSTER_CONFIG}"
fi

# Start jira as the correct user.
if [ "${UID}" -eq 0 ]; then
    echo "User is currently root. Will change directory ownership to ${JIRA_AGENT_USER}:${JIRA_AGENT_GROUP}, then downgrade permission to ${JIRA_AGENT_USER}"
    PERMISSIONS_SIGNATURE=$(stat -c "%u:%U:%a" "${JIRA_AGENT_HOME}")
    EXPECTED_PERMISSIONS=$(id -u ${JIRA_AGENT_USER}):${JIRA_AGENT_USER}:700
    if [ "${PERMISSIONS_SIGNATURE}" != "${EXPECTED_PERMISSIONS}" ]; then
        echo "Updating permissions for JIRA_AGENT_HOME"
        mkdir -p "${JIRA_AGENT_HOME}/lib" &&
            chmod -R 700 "${JIRA_AGENT_HOME}" &&
            chown -R "${JIRA_AGENT_USER}:${JIRA_AGENT_GROUP}" "${JIRA_AGENT_HOME}"
    fi
    # Now drop privileges
    echo "Executing with downgraded permissions"
    exec su -s /bin/bash "${JIRA_AGENT_USER}" -c java -jar "${JIRA_AGENT_INSTALL}/${JIRA_AGENT_JAR} ${JIRA_AGENT_SERVER} ${ARGS}"
else
    echo "Executing with default permissions"
    exec "${JIRA_INSTALL}"/bin/start-jira.sh ${ARGS}
fi
