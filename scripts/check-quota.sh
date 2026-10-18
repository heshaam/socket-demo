#!/usr/bin/env bash
source ../.env
set -euo pipefail
SOCKET_QUOTA_URL='https://api.socket.dev/v0/quota'
curl -sS -D - -H "Authorization: Bearer ${SOCKET_SCAN_TOKEN}" "$SOCKET_QUOTA_URL"
