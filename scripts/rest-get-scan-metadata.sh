#!/usr/bin/env bash
source ../.env
set -euo pipefail
#Fetch the scan ID from the previous response
fetchId=$(jq '.id' evidence/rest-full-scan-response.json)
SOCKET_FULL_SCAN_ID="${fetchId//\"/}"
SOCKET_GET_SCAN_URL="https://api.socket.dev/v0/orgs/heshaam-attar-org/full-scans/${SOCKET_FULL_SCAN_ID}/metadata"
# Set curl arguments
args=(-o evidence/rest-get-scan.json -w '%{http_code}')
args+=(-H "Authorization: Bearer ${SOCKET_SCAN_TOKEN}" -H 'Accept: application/json')
# Run curl to execute full scan
code="$(curl -sS "${args[@]}" "$SOCKET_GET_SCAN_URL")"
printf 'HTTP status: %s\nResponse saved to evidence/rest-get-scan.json\n' "$code"
# Inspect response/status
case "$code" in 2*) ;; *) echo 'API call unsuccessful: inspect response and verify auth and endpoint' >&2; exit 1;; esac
