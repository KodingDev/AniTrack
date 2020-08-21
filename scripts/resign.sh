#!/bin/sh

set -e

INPUT=$1
OUTPUT=$2
FAKEENT="/tmp/fakeent.plist"

cat >"$FAKEENT" <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>get-task-allow</key>
	<true/>
	<key>dynamic-codesigning</key>
	<true/>
</dict>
</plist>
EOL

mkdir -p "$OUTPUT"
rm -rf "$OUTPUT/Payload" "$OUTPUT/Runner.ipa"
cp -r "$INPUT" "$OUTPUT/Payload"
find "$OUTPUT/Payload" -type f -path '*/Frameworks/*.dylib' -exec ldid -S \{\} \;
ldid -S${FAKEENT} "$OUTPUT/Payload/Runner.app/Runner"
cd "$OUTPUT"
zip -r "Runner.ipa" "Payload" -x "._*" -x ".DS_Store" -x "__MACOSX"
rm -r "Payload"

rm "$FAKEENT"