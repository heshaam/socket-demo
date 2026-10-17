#!/usr/bin/env bash
set -euo pipefail
: "${SOCKET_FIREWALL_REGISTRY:?Set verified Firewall registry URL}"
case "$SOCKET_FIREWALL_REGISTRY" in
  http://127.0.0.1:*|http://localhost:*|https://*) ;;
  *) echo 'Registry URL must be localhost or HTTPS. Refusing unsafe test.' >&2; exit 2;;
esac
if [[ "${CONFIRM_FIREWALL_ENFORCEMENT:-}" != 'yes' ]]; then
 echo 'First confirm this endpoint is Socket Firewall registry mode with org policy blocking malware.' >&2
 echo 'Then rerun with CONFIRM_FIREWALL_ENFORCEMENT=yes.' >&2; exit 2
fi
mkdir -p evidence
work="$(mktemp -d)"; trap 'rm -rf "$work"' EXIT
printf '{"name":"socket-firewall-block-test","private":true,"version":"1.0.0"}
' > "$work/package.json"
echo "Testing Socket Firewall at $SOCKET_FIREWALL_REGISTRY (never public npm)"
set +e
(cd "$work" && npm install --ignore-scripts --no-save --no-audit --no-fund --registry "$SOCKET_FIREWALL_REGISTRY" 'lodahs@0.0.1-security') 2>&1 | tee evidence/firewall-block.txt
rc=${PIPESTATUS[0]}
set -e
printf 'npm exit code: %s
' "$rc" | tee -a evidence/firewall-block.txt
if [[ "$rc" -eq 0 ]]; then echo 'UNSAFE/UNEXPECTED: package install succeeded; block NOT demonstrated.' >&2; exit 1; fi
echo 'Install failed. Verify the response specifically identifies Socket organization policy; network errors are NOT proof of enforcement.'
