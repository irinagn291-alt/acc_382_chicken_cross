#!/bin/bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FACTORY_DIR="$(cd "$TASK_DIR/../../../.." && pwd)"
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
export PATH="$FACTORY_DIR/scripts/bin:$PATH"
export GF_BUILD_LOCK="$FACTORY_DIR/.artifacts/locks/build.lock"
: "${GF_SIMULATOR_UDID:?Launch this entire script with simulator_pool.py}"
LABEL="${1:-phone}"
mkdir -p "$TASK_DIR/Evidence/$LABEL"
xcrun simctl boot "$GF_SIMULATOR_UDID"
xcrun simctl bootstatus "$GF_SIMULATOR_UDID" -b
xcrun simctl status_bar "$GF_SIMULATOR_UDID" override --time '9:41' --batteryState charged --batteryLevel 100
xcodebuild -project "$TASK_DIR/SunnyPlume.xcodeproj" -scheme Sunfoot -configuration DawnDebug -derivedDataPath "$TASK_DIR/Artifacts/DerivedData" -resultBundlePath "$TASK_DIR/Evidence/$LABEL/Checks.xcresult" -destination "id=$GF_SIMULATOR_UDID" -parallel-testing-enabled NO CODE_SIGNING_ALLOWED=NO ONLY_ACTIVE_ARCH=YES ARCHS=arm64 test > "$TASK_DIR/Evidence/$LABEL/tests.log" 2>&1
RESULT=$?
xcrun xcresulttool export attachments --path "$TASK_DIR/Evidence/$LABEL/Checks.xcresult" --output-path "$TASK_DIR/Evidence/$LABEL/Attachments" > "$TASK_DIR/Evidence/$LABEL/export.log" 2>&1
xcrun xcresulttool get test-results summary --path "$TASK_DIR/Evidence/$LABEL/Checks.xcresult" > "$TASK_DIR/Evidence/$LABEL/summary.json" 2>&1
xcrun simctl launch "$GF_SIMULATOR_UDID" org.sunnyplume.trail441 -AppleLanguages '(en)' -AppleLocale en_US
sleep 3
xcrun simctl io "$GF_SIMULATOR_UDID" screenshot "$TASK_DIR/Evidence/$LABEL/ColdLaunch.png"
xcrun simctl spawn "$GF_SIMULATOR_UDID" log show --last 8m --predicate 'process == "SunnyPlume"' --style compact > "$TASK_DIR/Evidence/$LABEL/runtime.log" 2>&1
printf '%s\n' "$RESULT" > "$TASK_DIR/Evidence/$LABEL/test-exit-code.txt"
python3 "$TASK_DIR/Tools/Report.py"
python3 "$TASK_DIR/Tools/Deliver.py"
exit "$RESULT"
