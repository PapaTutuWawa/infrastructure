#!/bin/sh

DEPLOY_DEST="/srv/infrastructure"
DEPLOY_BAK="$DEPLOY_DEST.bak"
SCRIPT_PATH=$(cd "$(dirname $0)" && pwd)

# Stop the composition
cd "$DEPLOY_DEST" && docker-compose down

# Rename the old
mv "$DEPLOY_DEST/" "$DEPLOY_BAK/"

# Copy the new code
cp -r "$SCRIPT_PATH" "$DEPLOY_DEST"

# Build the "composition" (and feel like a musician)
cd "$DEPLOY_DEST" && docker-compose build
if [ ! $? -eq 0 ]; then
    echo "Build failed..."
    echo "Restoring..."

    rm -rf "$DEPLOY_DEST"
    mv "$DEPLOY_BAK" "$DEPLOY_DEST"

    exit 1
fi

# Deployment was a success
echo "Successful build!"

# Remove things we don't need
echo "Removing unnecessary folders"
rm -rf "$DEPLOY_DEST/.git"

# Chown and chmod the directory
echo "chmoding and chowning the deployment"
chown -R root "$DEPLOY_DEST"
chmod -R 700 "$DEPLOY_DEST"

# Start the composition
echo "Starting docker composition"
cd "$DEPLOY_DEST" && docker-compose up -d

if [ ! $? -eq 0 ]; then
    echo "Starting of the composition failed"
    exit 1
fi

echo "Removing the backup"
rm -rf "$DEPLOY_BAK"
