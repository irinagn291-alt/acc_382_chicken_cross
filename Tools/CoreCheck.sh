#!/bin/bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "$0")/.." && pwd)"
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
CORE_DIR="$TASK_DIR/Artifacts/HostCore"
PLATFORM_DIR="$DEVELOPER_DIR/Platforms/MacOSX.platform/Developer"
mkdir -p "$CORE_DIR" "$TASK_DIR/Evidence/CoreChecks.xctest/Contents/MacOS"
xcrun swiftc -emit-library -emit-module -enable-testing -module-name SunnyPlume -swift-version 5 -module-cache-path "$CORE_DIR/Cache" "$TASK_DIR/Source/PlumeLedger.swift" -o "$CORE_DIR/libSunnyPlume.dylib" -emit-module-path "$CORE_DIR/SunnyPlume.swiftmodule"
xcrun swiftc -emit-library -module-name PlumeCoreChecks -D CC_CORE_HOST -swift-version 5 -module-cache-path "$CORE_DIR/Cache" -I "$CORE_DIR" -L "$CORE_DIR" -lSunnyPlume -I "$PLATFORM_DIR/usr/lib" -L "$PLATFORM_DIR/usr/lib" -F "$PLATFORM_DIR/Library/Frameworks" -Xlinker -rpath -Xlinker "$CORE_DIR" -Xlinker -rpath -Xlinker "$PLATFORM_DIR/Library/Frameworks" -Xlinker -rpath -Xlinker "$PLATFORM_DIR/usr/lib" "$TASK_DIR/Checks/CrossingChecks.swift" -o "$TASK_DIR/Evidence/CoreChecks.xctest/Contents/MacOS/PlumeCoreChecks"
python3 - "$TASK_DIR" <<'PY'
import plistlib,sys
from pathlib import Path
p=Path(sys.argv[1])/'Evidence/CoreChecks.xctest/Contents/Info.plist'
p.write_bytes(plistlib.dumps({'CFBundleIdentifier':'org.sunnyplume.core441','CFBundleName':'PlumeCoreChecks','CFBundleExecutable':'PlumeCoreChecks','CFBundlePackageType':'BNDL','CFBundleVersion':'1'}))
PY
mkdir -p "$CORE_DIR/Preferences"
CFFIXED_USER_HOME="$CORE_DIR/Preferences" xcrun xctest "$TASK_DIR/Evidence/CoreChecks.xctest"
