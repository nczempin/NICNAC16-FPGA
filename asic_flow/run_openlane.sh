#!/usr/bin/env bash
# Stub script to run OpenLane flow for NICNAC16
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v openlane >/dev/null 2>&1; then
    echo "OpenLane is not installed or not in PATH" >&2
    exit 1
fi

# Placeholder invocation of OpenLane
openlane "$SCRIPT_DIR/.." -config "$SCRIPT_DIR/config.tcl" || { 
    echo "OpenLane run script is a stub."; 
    exit 1; 
}
