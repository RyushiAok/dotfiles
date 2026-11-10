#!/usr/bin/env bash
set -euo pipefail

export OP_BIOMETRIC_UNLOCK_ENABLED=true
readonly ENV_FILE="${1:-$HOME/.config/secrets/.env.op}"

[[ -f "$ENV_FILE" ]] || { echo "Not found: $ENV_FILE" >&2; exit 1; }

strip_quotes() { local s="$1"; s="${s%\"}"; s="${s#\"}"; printf '%s' "$s"; }

grep -v '^\s*#' "$ENV_FILE" \
  | grep -v '^\s*$' \
  | while IFS='=' read -r key op_ref; do
      op_ref=$(strip_quotes "$op_ref")
      echo "sync: $key <- $op_ref"
      val=$(op read "$op_ref") || { echo "  failed: $key" >&2; continue; }
      /usr/bin/security add-generic-password -U -a "$USER" -s "$key" -w "$val"
    done
echo "done"
