#!/bin/sh

SOURCE_PATH=${SOURCE_PATH:-/source}
TARGET_PATH=${TARGET_PATH:-/destination}
EXCLUDE_PATTERN=${EXCLUDE_PATTERN:-''}

EXCLUDE_PATTERN="${EXCLUDE_PATTERN#\"}"
EXCLUDE_PATTERN="${EXCLUDE_PATTERN%\"}"
EXCLUDE_LIST=$(echo $EXCLUDE_PATTERN | sed "s/,/','/g")

cat <<EOF >/etc/lsyncd.conf
settings {
  pidfile = "/var/run/lsyncd.pid",
  nodaemon = "true"
}
sync {
  default.direct,
  source = '${SOURCE_PATH}',
  target = '${TARGET_PATH}',
  exclude = { '${EXCLUDE_LIST}' }
}
EOF

exec /usr/bin/lsyncd -nodaemon /etc/lsyncd.conf