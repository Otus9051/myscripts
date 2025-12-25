#!/bin/bash

# A script to install extracted split APK as com.android.vending

APK_DIR="."
INSTALLER="com.android.vending"

# 1. Get all APKs
APKS=( *.apk )
echo "Installing:"
echo "$APKS"

# 2. Calculate total size (in bytes)
TOTAL_SIZE=$(du -bc *.apk | tail -n1 | cut -f1)

echo "Creating installation session via adb"

# 3. Create session and extract ID
SESSION_ID=$(adb shell pm install-create -i "$INSTALLER" -S $TOTAL_SIZE | grep -o '\[.*\]' | tr -d '[]\r')

if [ -z "$SESSION_ID" ]; then
    echo "Error: Could not create session. Is your phone connected and ADB authorized?"
    exit 1
fi

echo "Session ID: $SESSION_ID"

# 4. Stream the APKs
for apk in "${APKS[@]}"; do
    FILE_SIZE=$(stat -c%s "$apk")
    echo "Streaming $apk ($FILE_SIZE bytes)..."
    $ADB_PATH shell pm install-write -S $FILE_SIZE $SESSION_ID "$apk" - < "$apk"
done

# 5. Commit
echo "Committing installation..."
$ADB_PATH shell pm install-commit $SESSION_ID

echo "Process complete."
