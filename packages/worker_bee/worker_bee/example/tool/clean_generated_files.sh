#!/usr/bin/env bash
# Deletes auto-generated files produced by worker_bee_builder.
# Idempotent – safe to run multiple times.
# All paths are relative to the script's location, not the caller's cwd.

set -euo pipefail

# Resolve the example project root (one level up from tool/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Cleaning generated files in: $PROJECT_DIR"

#
# 1. Root-level patterns from example/.gitignore
#    *.dart2js.*  *.min.*  *.wasm*  *.mjs  *.js
#    workers.debug.dart  workers.release.dart
#
find "$PROJECT_DIR/lib" -type f \( \
  -name '*.dart2js.*' -o \
  -name '*.min.*' -o \
  -name '*.wasm*' -o \
  -name '*.mjs' -o \
  -name '*.js' \
\) -print -delete

for f in workers.debug.dart workers.release.dart; do
  target="$PROJECT_DIR/lib/$f"
  if [ -f "$target" ]; then
    echo "  rm $target"
    rm "$target"
  fi
done

#
# 2. lib/models/.gitignore
#    echo_message.g.dart
#
target="$PROJECT_DIR/lib/models/echo_message.g.dart"
if [ -f "$target" ]; then
  echo "  rm $target"
  rm "$target"
fi

#
# 3. lib/workers/.gitignore
#    echo_worker.g.dart
#    echo_worker.worker.dart
#    echo_worker.worker.js.dart
#    echo_worker.worker.vm.dart
#
for f in echo_worker.g.dart echo_worker.worker.dart echo_worker.worker.js.dart echo_worker.worker.vm.dart; do
  target="$PROJECT_DIR/lib/workers/$f"
  if [ -f "$target" ]; then
    echo "  rm $target"
    rm "$target"
  fi
done

echo "Done."
