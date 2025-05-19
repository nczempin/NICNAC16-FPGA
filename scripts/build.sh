#!/usr/bin/env bash
set -e

echo "Running build script..."
# create artifact (zip docs and images)
output="build_artifacts.zip"
rm -f "$output"
zip -r "$output" docs pictures *.png > /dev/null 2>&1 || true

echo "Created $output"

# Run HDL tests when requested
if [[ "$RUN_TESTS" == "1" ]]; then
  echo "Running HDL tests"
  bash "$(dirname "$0")/test.sh"
fi
