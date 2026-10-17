#!/usr/bin/env bash
set -uo pipefail
mkdir -p evidence
if ! command -v socket >/dev/null 2>&1; then echo 'Install the official Socket CLI first.' >&2; exit 2; fi
# CLI flags differ by version. Explicitly set the complete command as arguments.
# Usage: ./scripts/cli-scan.sh scan <confirmed-flags-and-targets>
if [[ "$#" -eq 0 ]]; then echo 'Usage: ./scripts/cli-scan.sh <socket subcommand and verified args>' >&2; exit 2; fi
set +e
socket "$@" 2>&1 | tee evidence/cli-output.txt
status=${PIPESTATUS[0]}
set -e
printf 'Socket CLI exit code: %s\n' "$status" | tee evidence/cli-exit.txt
exit "$status"
