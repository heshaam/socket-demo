#!/usr/bin/env bash
source ../.env
set -euo pipefail
mkdir -p evidence
SOCKET_FULL_SCAN_URL="https://api.socket.dev/v0/orgs/heshaam-attar-org/full-scans?repo=socket-demo&workspace=Demo&branch=main&make_default_branch=false&set_as_pending_head=false&tmp=false&scan_type=socket"
# Set curl arguments
args=(-sS -D evidence/rest-full-scan-headers.txt -o evidence/rest-full-scan-response.json -w '%{http_code}' -X POST)
args+=(-H "Authorization: Bearer ${SOCKET_TOKEN}" -H 'Accept: application/json')
args+=(-F package.json=@../apps/web/package.json)
args+=(-F requirements.txt=@../services/python-api/requirements.txt)
# Run curl to execute full scan
code="$(curl "${args[@]}" "$SOCKET_FULL_SCAN_URL")"
printf 'HTTP status: %s\nResponse saved to evidence/rest-full-scan-response.json\n' "$code"
# Inspect response/status
case "$code" in 2*) ;; *) echo 'API call unsuccessful: inspect response and verify auth, endpoint and multipart schema' >&2; exit 1;; esac
