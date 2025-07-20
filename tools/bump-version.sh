#!/bin/bash
# Version update script for wallcontroller firmware

# Paths
VERSION_FILE="/home/thomas/wallcontroller-feed/wallcontroller-version/files/version.json"
MAKEFILE="/home/thomas/wallcontroller-feed/wallcontroller-version/Makefile"

# Parse arguments
BUMP_TYPE="patch"
if [ "$1" == "major" ] || [ "$1" == "minor" ] || [ "$1" == "patch" ]; then
    BUMP_TYPE="$1"
fi

# Read current version from Makefile
CURRENT_VERSION=$(grep "PKG_VERSION:=" "$MAKEFILE" | cut -d'=' -f2)

# Parse version components
MAJOR=$(echo "$CURRENT_VERSION" | cut -d. -f1)
MINOR=$(echo "$CURRENT_VERSION" | cut -d. -f2)
PATCH=$(echo "$CURRENT_VERSION" | cut -d. -f3)

# Increment version based on bump type
if [ "$BUMP_TYPE" == "major" ]; then
    MAJOR=$((MAJOR+1))
    MINOR=0
    PATCH=0
elif [ "$BUMP_TYPE" == "minor" ]; then
    MINOR=$((MINOR+1))
    PATCH=0
else
    PATCH=$((PATCH+1))
fi

# Create new version string
NEW_VERSION="$MAJOR.$MINOR.$PATCH"

# Update Makefile
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$NEW_VERSION/g" "$MAKEFILE"
sed -i "s/PKG_RELEASE:=.*/PKG_RELEASE:=1/g" "$MAKEFILE"

# Update version.json
sed -i "s/\"firmware_version\": \".*\"/\"firmware_version\": \"$NEW_VERSION\"/g" "$VERSION_FILE"
sed -i "s/\"build_date\": \".*\"/\"build_date\": \"$(date +%Y-%m-%d)\"/g" "$VERSION_FILE"

# Update release_notes.txt with template for new version
NOTES_FILE="/home/thomas/wallcontroller-feed/wallcontroller-version/files/release_notes.txt"
NEW_NOTES="# Wallcontroller Firmware v$NEW_VERSION\n\n## New Features\n- \n\n## Bug Fixes\n- \n\n## Known Issues\n- \n\n$(cat "$NOTES_FILE")"
echo -e "$NEW_NOTES" > "$NOTES_FILE"

echo "Version updated to $NEW_VERSION"
