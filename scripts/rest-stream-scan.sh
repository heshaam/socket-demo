#!/usr/bin/env bash
source ../.env
set -euo pipefail
fetchId=$(jq '.id' evidence/rest-full-scan-response.json)
SOCKET_FULL_SCAN_ID="${fetchId//\"/}"
SOCKET_STREAM_SCAN_URL="https://api.socket.dev/v0/orgs/heshaam-attar-org/full-scans/${SOCKET_FULL_SCAN_ID}?include_alert_priority_details=false&include_scores=false&include_scores_details=false&include_license_details=false&cached=false&if_cached=false"
# Set curl arguments
args=(-o evidence/rest-stream-scan.json -w '%{http_code}')
args+=(-H "Authorization: Bearer ${SOCKET_TOKEN}" -H 'Accept: application/json')
# Run curl to execute full scan
code="$(curl "${args[@]}" "$SOCKET_STREAM_SCAN_URL")"
printf 'HTTP status: %s\nResponse saved to evidence/rest-stream-scan.json\n' "$code"
# Inspect response/status
case "$code" in 2*) ;; *) echo 'API call unsuccessful: inspect response and verify auth and endpoint' >&2; exit 1;; esac
