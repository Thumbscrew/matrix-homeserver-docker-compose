#!/usr/bin/env sh
set -eu

envsubst '${SERVER_NAME} ${HTTPS_PORT} ${FEDERATION_HTTPS_PORT} ${SSL_CERT_PATH} ${SSL_KEY_PATH}' < /tmp/nginx/default.conf > /etc/nginx/conf.d/default.conf

exec "$@"