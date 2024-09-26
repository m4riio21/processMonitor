#!/bin/bash

# Help function to display the usage of the script
show_help() {
  echo "Usage: $0 --ip <IP> --user <USER> --password <PASSWORD> [--arch <ARCH>]"
  echo
  echo "Options:"
  echo "  --ip        Remote system's IP address."
  echo "  --user      Username to log in to the remote system."
  echo "  --password  Password to log in to the remote system."
  echo "  --arch      Architecture type (32 or 64). Defaults to 64-bit."
  echo
  echo "Example:"
  echo "  $0 --ip 192.168.1.10 --user root --password 12345 --arch 64"
}

# Check if no arguments are passed and display the help panel
if [ "$#" -eq 0 ]; then
  show_help
  exit 1
fi

# Initialize variables
IP=""
USER=""
PASSWORD=""
ARCH="64"  # Default architecture is 64-bit

# Parse the input arguments
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --ip)
      IP="$2"
      shift 2
      ;;
    --user)
      USER="$2"
      shift 2
      ;;
    --password)
      PASSWORD="$2"
      shift 2
      ;;
    --arch)
      ARCH="$2"
      shift 2
      ;;
    *)
      echo "Invalid argument: $1"
      show_help
      exit 1
      ;;
  esac
done

# Check if the required arguments are provided
if [ -z "$IP" ] || [ -z "$USER" ] || [ -z "$PASSWORD" ]; then
  echo "Error: --ip, --user, and --password are required parameters."
  show_help
  exit 1
fi

# Determine the pspy download link based on architecture
if [ "$ARCH" = "32" ]; then
  PSPY_URL="https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy32"
  PSPY_FILE="pspy32"
elif [ "$ARCH" = "64" ]; then
  PSPY_URL="https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64"
  PSPY_FILE="pspy64"
else
  echo "Error: Unsupported architecture type. Please use 32 or 64."
  exit 1
fi

# Download pspy binary
echo "Downloading $PSPY_FILE from $PSPY_URL..."
wget -q "$PSPY_URL" -O "$PSPY_FILE"

# Check if the download was successful
if [ ! -f "$PSPY_FILE" ]; then
  echo "Error: Failed to download $PSPY_FILE."
  exit 1
fi

# Transfer the pspy binary to the remote system using SCP
echo "Transferring $PSPY_FILE to $USER@$IP:/tmp..."
sshpass -p "$PASSWORD" scp "$PSPY_FILE" "$USER@$IP:/tmp/"

# Check if the SCP transfer was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to transfer $PSPY_FILE to $USER@$IP."
  exit 1
fi

# Run pspy on the remote system
echo "Running $PSPY_FILE on the remote system..."
sshpass -p "$PASSWORD" ssh "$USER@$IP" "chmod +x /tmp/$PSPY_FILE && /tmp/$PSPY_FILE"

# Cleanup: Optionally remove the local pspy file after use
rm "$PSPY_FILE"

echo "Process monitoring started on the remote system."
