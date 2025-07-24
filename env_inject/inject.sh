#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Allow passing a custom .env file path as the first argument
if [ -n "$1" ]; then
    ENV_FILE="$1"
else
    ENV_FILE="$SCRIPT_DIR/.env"
fi

echo "Looking for .env file in: $ENV_FILE"

# Check if .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: .env file not found at $ENV_FILE"
    exit 1
fi

echo "Found .env file, reading variables..."

# Read .env file and export variables
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
        echo "Skipping comment or empty line"
        continue
    fi
    
    # Remove any leading/trailing whitespace
    line=$(echo "$line" | xargs)
    
    # Debug output
    echo "Processing line: $line"
    
    # Export the variable
    if [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*=.* ]]; then
        eval "export $line"
        # echo "Exported: $line"
    else
        echo "Warning: Invalid variable format in line: $line"
    fi
done < "$ENV_FILE"

echo "Environment variables loaded successfully"

# $source inject_env.sh
