# Folder Sync Script

This script (`sync.sh`) uses `rsync` to synchronize one or more local folders to a destination directory, with support for excluding specific files and directories. It is designed to be flexible and configurable via a `.env` file.

## Description
- Syncs multiple source directories to a single destination directory.
- Excludes specified files and directories from syncing (e.g., `.git/`, `node_modules/`).
- Watches for file changes and automatically re-syncs when changes are detected.
- Automatically restarts the sync process if it fails.

## Prerequisites
- **bash**
- **rsync**
- **fswatch** (install via `brew install fswatch` on macOS)

## Installation

### macOS
Install Homebrew if you don't have it:
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Then install the required tools:
```sh
brew install rsync fswatch
```

### Linux (Debian/Ubuntu)
Update your package list and install the tools:
```sh
sudo apt update
sudo apt install bash rsync fswatch
```

### Linux (Fedora/RHEL)
```sh
sudo dnf install bash rsync fswatch
```

*Note: `bash` and `rsync` are usually pre-installed on most systems. If you get a 'command not found' error, use the above commands to install them.*

## Setup
1. **Clone or copy this script to your machine.**
2. **Create a `.env` file in the same directory as `sync.sh`** (see `.env.example` for the required format):

   ```env
   SOURCE_DIRS="/path/to/source1,/path/to/source2"
   DEST_DIR="/path/to/destination"
   EXCLUDES_DIRS=".git/,node_modules/,some/other/dir/,file_to_exclude.txt"
   ```

3. **Make the script executable:**
   ```sh
   chmod +x sync.sh
   ```

## Usage
Run the script from the `folder_sync` directory:

```sh
./sync.sh
```

- The script will perform an initial sync and then watch for changes in the source directories, syncing automatically when changes are detected.
- If the sync process fails, it will automatically restart after a short delay.

## Notes
- The script uses comma-separated lists for `SOURCE_DIRS` and `EXCLUDES_DIRS` in the `.env` file.
- Make sure the destination directory exists and you have write permissions.
- Adjust the paths in your `.env` file to match your system.
- For Google Drive or other cloud sync folders, ensure the destination path is correct and syncing is enabled. 