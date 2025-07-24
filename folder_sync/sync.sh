#!/bin/bash
# Sync folders
# This script uses rsync to synchronize folders to a directory.
# It excludes certain directories like .git and node_modules to avoid syncing unnecessary files.
# Make sure to adjust the paths according to your system.
# Usage: ./sync.sh

# Load environment variables from .env file
if [ -f ".env" ]; then
  set -o allexport
  source .env
  set +o allexport
else
  echo ".env file not found! Exiting."
  exit 1
fi

# Parse array variables from .env (comma-separated)
IFS=',' read -r -a SOURCE_DIRS <<< "$SOURCE_DIRS"
IFS=',' read -r -a EXCLUDES_DIRS <<< "$EXCLUDES_DIRS"



# Build the exclude parameters dynamically
EXCLUDE_PARAMS=()
for dir in "${EXCLUDES_DIRS[@]}"; do
  EXCLUDE_PARAMS+=(--exclude="$dir")
done



# Use the SOURCE_DIRS array in the rsync command
# Build the rsync command and store it in a variable
RSYNC_COMMAND="rsync -av --no-links --delete --omit-dir-times ${EXCLUDE_PARAMS[@]} ${SOURCE_DIRS[@]} \"$DEST_DIR\""

# Execute the command
eval $RSYNC_COMMAND

# Watch for file changes and run rsync when changes are detected
fswatch -o -r -t ${SOURCE_DIRS[@]} | while read file; do
  echo "File changed: $file"
  echo "Syncing files..."
  # Execute the rsync command (remove the 'n' flag to actually perform the sync instead of dry-run)
  eval $RSYNC_COMMAND
  echo "Sync completed at $(date)"
done

# Function to restart the sync process if it fails
restart_sync() {
  echo "Restarting sync process at $(date)..."
  # Loop forever
  while true; do
    # Start fswatch with error handling
    fswatch -o -r -t ${SOURCE_DIRS[@]} | while read file; do
      echo "File changed: $file"
      echo "Syncing files..."
      eval $RSYNC_COMMAND
      echo "Sync completed at $(date)"
    done
    
    echo "fswatch exited unexpectedly at $(date)"
    echo "Waiting 5 seconds before restarting..."
    sleep 5
  done
}

# Start the sync process with restart capability
restart_sync