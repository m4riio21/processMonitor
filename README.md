# processMonitor.sh

`processMonitor.sh` is a Bash script designed to download and monitor processes on a remote system using the `pspy` utility. It automates the following tasks:

- Downloads the `pspy` binary (32-bit or 64-bit based on user input or default).
- Transfers the `pspy` binary to a remote system via `scp`.
- Executes the `pspy` binary on the remote system to monitor running processes.

This script requires the remote system's IP address, user credentials, and optionally the architecture type (32-bit or 64-bit) for the `pspy` binary.
