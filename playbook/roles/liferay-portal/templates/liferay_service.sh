#!/bin/bash
### BEGIN INIT INFO
# Provides:          liferay
# Required-Start:    $local_fs $remote_fs $network
# Required-Stop:     $local_fs $remote_fs $network
# Should-Start:      $named
# Should-Stop:       $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Liferay portal daemon.
# Description:       Starts the Liferay portal.
# Author:            Julien Rialland <julien.rialland@gmail.com>
# Author:            Milen Dyankov <milen.dyankov@liferay.com>
### END INIT INFO

#Display name of the application
APP_NAME="Liferay"

#Location of Liferay installation
export LIFERAY_HOME={{ liferay_home }}

#unprivileged user that runs the daemon. The group/user should have been created separately,
#using groupadd/useradd
USER={{ liferay_os_user }}
GROUP={{ liferay_os_group }}

###This is end of the configurable section for most cases, other variable definitions follow :

#Only root user may run this script
if [ `id -u` -ne 0 ]; then
	echo "You need root privileges to run this script"
	exit 1
fi

#tomcat directory
#detection of the tomcat directory within liferay
TOMCAT_DIR=`ls "$LIFERAY_HOME" | grep tomcat | head -1`
export CATALINA_HOME="$LIFERAY_HOME/$TOMCAT_DIR"

#location of pid file
export CATALINA_PID=/var/run/liferay/liferay.pid

# guess where is JAVA_HOME if needed (when then environment variable is not defined)
JVM_DIRS="/usr/lib/jvm/java-8-oracle /usr/lib/jvm/java-6-sun /usr/lib/jvm/default-java /usr/lib/jvm/java-1.5.0-sun /usr/usr/lib/j2sdk1.5-sun /usr/lib/j2sdk1.5-ibm"
if [ -z "$JAVA_HOME" ]; then
        for jdir in $JVM_DIRS; do
                if [ -r "$jdir/bin/java" -a -z "${JAVA_HOME}" ]; then
                        export JAVA_HOME="$jdir"
                fi
        done
fi

#if JAVA_HOME is still undefined, try to get it by resolving the path to the java program
if [ -z "$JAVA_HOME" ]; then
        javaexe=`which java`
        if [ ! -z "$javaexe" ]; then
                javaexe=`readlink -m "$javaexe"`
                jdir="$javaexe/../.."
                export JAVA_HOME=`readlink -m "$jdir"`
        fi
fi

#if JAVA_HOME is still undefined, crash the script
if [ -z "$JAVA_HOME" ]; then
	echo 'The JAVA_HOME environment variable could not be determined !'
	exit 1
fi

#extra jvm configuration : enable jmx
#export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.port=9999 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

#extra jvm configuration : enable remote debugging
#export JAVA_OPTS="$JAVA_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=9998" 

################################################################################

#verify that the user that will run the daemon exists
id "$USER" > /dev/null 2>&1
if [ "$?" -ne "0" ]; then
	echo "User $user does not exist !"
	exit 1
fi

#load utility functions from Linux Standard Base
. /lib/lsb/init-functions

#starts the daemon service
function start {
        log_daemon_msg "Starting $APP_NAME"

        #create work directory if non-existent
        mkdir $CATALINA_HOME/work 2>/dev/null

        #clear temp directory
        rm -rf "$CATALINA_HOME/temp/*" 2>/dev/null
        mkdir $CATALINA_HOME/temp 2>/dev/null

        #fix user rights on liferay home dir
        chown -R "$USER":"$GROUP" "$LIFERAY_HOME"
        #chmod -R ug=rwx "$LIFERAY_HOME"

        #ensure that pid file is writeable
        mkdir `dirname "$CATALINA_PID"` 2>/dev/null
        chown -R "$USER":"$GROUP" `dirname "$CATALINA_PID"`

        su "$USER" -c "$CATALINA_HOME/bin/catalina.sh start"
        status=$?

        log_end_msg $status
        exit $status
}

#stops the daemon service
function stop {
        log_daemon_msg "Stopping $APP_NAME"
        if [ ! -f "$CATALINA_PID" ];then
            echo "file $CATALINA_PID is missing !"
            unset CATALINA_PID
        fi
        su "$USER" -c "$CATALINA_HOME/bin/catalina.sh stop 10 -force"
        status=$?
        log_end_msg $status
        if [ "$status" = "0" ];then
            rm -f "$CATALINA_PID"
        fi
        exit $status
}

#restarts the daemon service
function restart {
        stop
        sleep 3s
        start
}

#prints service status
function status {
  if [ -f "$CATALINA_PID" ]; then
    pid=`cat "$CATALINA_PID"`
    echo "$APP_NAME is running with pid $pid"
    exit 0
  else
    echo "$APP_NAME is not running (or $CATALINA_PID is missing)"
    exit 1
  fi
}

case "$1" in
	start|stop|restart|status)
		$1
	;;
	*)
		echo $"Usage: $0 {start|stop|restart|status}"
		exit 1
	;;
esac
