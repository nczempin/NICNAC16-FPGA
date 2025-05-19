#!/usr/bin/env bash
set -e

missing=()
for cmd in g++ make cppcheck; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing+=("$cmd")
  fi
done

if [[ ${#missing[@]} -ne 0 ]]; then
  echo "Installing packages: ${missing[*]}"
  sudo apt-get update -y
  sudo apt-get install -y g++ make cppcheck
fi

for cmd in g++ make cppcheck; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: $cmd not installed" >&2
    exit 1
  fi
done

echo "All required packages are installed."
