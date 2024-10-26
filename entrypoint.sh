#!/bin/sh

TYPE=${TYPE:-rsync}
SOURCE_PATH=${SOURCE_PATH:-/source}
TARGET_PATH=${TARGET_PATH:-/destination}
SYNC_DELAY=${SYNC_DELAY:-1}
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
EOF

if [ "$TYPE" = "rsync" ]; then
  cat <<EOF >>/etc/lsyncd.conf
sync {
  default.rsync,
  source = '${SOURCE_PATH}',
  target = '${TARGET_PATH}',
  exclude = { '${EXCLUDE_LIST}' }
}
EOF

elif [ "$TYPE" = "rsyncssh" ]; then
  SSH_USER=${SSH_USER:-user}
  SSH_HOST=${SSH_HOST:-remotehost}
  SSH_PORT=${SSH_PORT:-22}
  SSH_KEY=${SSH_KEY:-/keys/id_rsa}

  cat <<EOF >>/etc/lsyncd.conf
sync {
  default.rsyncssh,
  source = '${SOURCE_PATH}',
  host = '${SSH_USER}@${SSH_HOST}',
  targetdir = '${TARGET_PATH}',
  rsync = {
    archive = true,
    compress = false,
    whole_file = false,
    rsh = "ssh -p ${SSH_PORT} -i ${SSH_KEY} -o StrictHostKeyChecking=no"
  },
  exclude = { '${EXCLUDE_LIST}' }
}
EOF

else
  echo "Unsupported TYPE: $TYPE. Please use 'rsync' or 'rsyncssh'."
  exit 1
fi

echo "---"
cat /etc/lsyncd.conf
echo "---"

exec /usr/bin/lsyncd -nodaemon /etc/lsyncd.conf