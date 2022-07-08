#!/bin/sh

## Log Function
readonly LOGFILE="/Library/Logs/TechSupport/jamf-install-log-increase.log"
readonly PROCNAME=${0##*/}
function log() {
  local fname=${BASH_SOURCE[1]##*/}
  /bin/echo "$(date '+%Y-%m-%dT%H:%M:%S') ${PROCNAME} (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $@" | tee -a ${LOGFILE}
}
  mkdir -p /Library/Logs/TechSupport/
  touch ${LOGFILE}

## Main
Check_Flag=`grep -i ttl /etc/asl/com.apple.install | awk -F'ttl=' '{print $2}'`
#CMD=`sed -i '' -e "s/expire-after:10M/expire-after:60D OR 1G/g" /etc/security/audit_control`

if [[ "$Check_Flag" = "" ]];
then
	mv /etc/asl/com.apple.install /etc/asl/com.apple.install.old
	sed '$s/$/ ttl=365/' /etc/asl/com.apple.install.old > /etc/asl/com.apple.install
	chmod 644 /etc/asl/com.apple.install
	chown root:wheel /etc/asl/com.apple.install
	log "install-log check"
	log "install-log check is NG"
	log "SUCCESS : Install Log increase 365days"
else if [[ "$Check_Flag" -lt "365" ]];
then
	mv /etc/asl/com.apple.install /etc/asl/com.apple.install.old
	sed "s/"ttl=$Check_Flag"/"ttl=365"/g" /etc/asl/com.apple.install.old > /etc/asl/com.apple.install
	chmod 644 /etc/asl/com.apple.install
	chown root:wheel /etc/asl/com.apple.install
	log "install-log check"
	log "install is NG"
	log "SUCCESS : Install Log increase 365days"
else
	log "install-log check"
	log "install is OK"
fi
fi
