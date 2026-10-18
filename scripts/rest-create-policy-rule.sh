#!/usr/bin/env bash
source ../.env
set -euo pipefail
SOCKET_CREATE_POLICY_URL="https://api.socket.dev/v0/orgs/${SOCKET_ORG_SLUG}/alert-policies/default/rules?dry_run=true"
# Set curl arguments
args=(-o evidence/rest-create-policy-rule.json -w '%{http_code}' -X POST)
args+=(-H "Authorization: Bearer ${SOCKET_POLICY_TOKEN}" -H 'Accept: application/json')
payload='{
    "name": "Warn on lodash install scripts",
    "vigil_selector": {
      "artifact.type": "npm",
      "artifact.name": {"$includes": "lodash"},
      "artifact.namespace": "@lodash",
      "finding.alertType": "installScripts",
      "artifact.version": {"$prefix": "2."}
    },
    "action": "warn",
    "note": "Demonstration of a scoped policy override",
    "position": "first"
  }'
# Run curl to execute full scan
code="$(curl -sS "${args[@]}" "$SOCKET_CREATE_POLICY_URL" -d "$payload")"
printf 'HTTP status: %s\nResponse saved to evidence/rest-create-policy-rule.json\n' "$code"
# Inspect response/status
case "$code" in 2*) ;; *) echo 'API call unsuccessful: inspect response and verify auth and endpoint' >&2; exit 1;; esac