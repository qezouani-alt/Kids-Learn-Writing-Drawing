#!/bin/bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 SIMULATOR_UDID OUTPUT_DIRECTORY" >&2
  exit 2
fi

device="$1"
output="$2"
capture_dir="$(mktemp -d /private/tmp/little-lines-shots.XXXXXX)"
mkdir -p "$output"

flutter drive \
  --driver=test_driver/app_store_screenshots.dart \
  --target=integration_test/app_store_screenshots_test.dart \
  -d "$device" 2>&1 | while IFS= read -r line; do
    printf '%s\n' "$line"
    if [[ "$line" =~ SCREENSHOT_READY:([a-zA-Z0-9_]+) ]]; then
      name="${BASH_REMATCH[1]}"
      xcrun simctl io "$device" screenshot "$capture_dir/$name.png"
    fi
  done

cp "$capture_dir"/*.png "$output/"
echo "Saved Simulator screenshots in $output"
