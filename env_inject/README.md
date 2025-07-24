# env_inject - Environment Variable Loader

This script (`inject.sh`) loads environment variables from a `.env` file and exports them into your current shell session. It is useful for quickly setting up environment variables for development or scripting purposes.

## Features
- Reads a `.env` file and exports all valid variables.
- Skips comments and empty lines.
- Allows you to specify a custom `.env` file path as an argument.

## Usage

### 1. Default Usage (uses `.env` in the script directory)
```sh
./inject.sh
```
This will look for a `.env` file in the same directory as the script and export its variables.

### 2. Custom .env File Path
```sh
./inject.sh /path/to/your/.env
```
Replace `/path/to/your/.env` with the path to your desired `.env` file.

## Notes
- The script must be executed with `source` if you want the variables to persist in your current shell:
  ```sh
  source ./inject.sh
  # or with a custom file
  source ./inject.sh /path/to/your/.env
  ```
- If you run the script directly (e.g., `./inject.sh`), the variables will only be available to the script's process and not your current shell.

## Example .env File
```
# This is a comment
API_KEY=your_api_key_here
DEBUG=true
```

## Error Handling
- If the `.env` file is not found, the script will print an error and exit.
- Lines that do not match the `KEY=VALUE` format will be skipped with a warning. 

# Making the Script Available Globally

To use `inject.sh` from any directory, you can either add an alias to your shell configuration or create a symlink to a directory in your `PATH`.

## Option 1: Add an Alias
Add the following line to your `~/.bashrc`, `~/.zshrc`, or equivalent shell config file:

```sh
alias envinject='source /absolute/path/to/env_inject/inject.sh'
```
Replace `/absolute/path/to/env_inject/inject.sh` with the full path to the script.

Now you can run:
```sh
envinject /path/to/your/.env
```

Or, to load a `.env` file from a specific folder:
```sh
envinject /path/to/your/folder/.env
```

## Option 2: Create a Symlink in Your PATH
You can create a symbolic link to the script in a directory that is in your `PATH`, such as `/usr/local/bin`:

```sh
ln -s /absolute/path/to/env_inject/inject.sh /usr/local/bin/envinject
```

To persist variables in your current shell, use:
```sh
source envinject /path/to/your/.env
```

## Using a Folder Path
If you want to pass a folder path and have the script automatically use the `.env` file inside that folder, you can create a wrapper function in your shell config:

```sh
envinject() {
  local target="$1"
  if [ -d "$target" ]; then
    source /absolute/path/to/env_inject/inject.sh "$target/.env"
  else
    source /absolute/path/to/env_inject/inject.sh "$target"
  fi
}
```
Now you can simply run:
```sh
envinject /path/to/your/folder
```
And it will load `/path/to/your/folder/.env` automatically.

---

With these steps, you can easily load environment variables from any directory or `.env` file on your system. 