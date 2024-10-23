#!/bin/sh

SOURCE_PATH=${SOURCE_PATH:-/source}
TARGET_PATH=${TARGET_PATH:-/destination}
SYNC_DELAY=${SYNC_DELAY:-0}
EXCLUDE_PATTERN=${EXCLUDE_PATTERN:-''}

EXCLUDE_PATTERN="${EXCLUDE_PATTERN#\"}"
EXCLUDE_PATTERN="${EXCLUDE_PATTERN%\"}"
EXCLUDE_LIST=$(echo $EXCLUDE_PATTERN | sed "s/,/','/g")

cat <<EOF >/etc/lsyncd.conf
settings {
  logfile = "/dev/stdout",
  pidfile = "/var/run/lsyncd.pid",
  nodaemon = "true"
}
sync {
  default.rsync,
  source = '${SOURCE_PATH}',
  target = '${TARGET_PATH}',
  exclude = { '${EXCLUDE_LIST}' }
}
EOF

exec /usr/bin/lsyncd -nodaemon /etc/lsyncd.conf