#!/usr/bin/env bash
# check-li-la-pseudoinstructions.sh
# SPDX-License-Identifier: Apache-2.0
# Pre-commit hook: require the fixed-length LI and LA macros instead of the
# variable-length li and la assembler pseudoinstructions.
# Usage: check-li-la-pseudoinstructions.sh <file>...

set -euo pipefail

pattern='(^|[[:space:];:"'"'"'])(li|la)(?![[:space:]]*\()[[:space:]]'

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  red=$'\033[31m'
  bold=$'\033[1m'
  reset=$'\033[0m'
else
  red=''
  bold=''
  reset=''
fi

found=0
for f in "$@"; do
  matches=$(grep -nPi "$pattern" "$f" || true)
  if [ -n "$matches" ]; then
    found=1
    while IFS= read -r line; do
      echo "$f:$line"
    done <<< "$matches"
  fi
done

if [ "$found" -ne 0 ]; then
  echo
  echo "${bold}${red}error:${reset} disallowed li/la assembler pseudoinstruction found above."
  echo "  Use LI(reg, imm) or LA(reg, label) instead."
  exit 1
fi
