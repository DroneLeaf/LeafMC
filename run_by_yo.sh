#!/usr/bin/env bash
# run_by_yo.sh
# Helper to detect - and optionally kill - an existing QGroundControl instance
# then run the staging QGroundControl binary.
# Usage:
#   ./run_by_yo.sh        # will attempt to kill any other QGroundControl instances and run staging/QGroundControl
#   ./run_by_yo.sh --no-kill   # will refuse to run if another instance exists
#   ./run_by_yo.sh --ask-kill  # will prompt before killing other instances
#   ./run_by_yo.sh --bin /path/to/QGroundControl  # run specified binary instead of build/staging/QGroundControl

set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_BIN="$SCRIPT_DIR/build/staging/QGroundControl"

NO_KILL=false
ASK_KILL=false
BIN="$DEFAULT_BIN"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-kill)
            NO_KILL=true; shift;;
        --ask-kill)
            ASK_KILL=true; shift;;
        --bin)
            BIN="$2"; shift 2;;
        --help|-h)
            echo "Usage: $0 [--no-kill] [--ask-kill] [--bin /path/to/QGroundControl]"; exit 0;;
        *)
            echo "Unknown arg: $1"; echo "Usage: $0 [--no-kill] [--ask-kill] [--bin /path/to/QGroundControl]"; exit 1;;
    esac
done

if [[ ! -x "$BIN" ]]; then
    echo "Error: binary not found or not executable: $BIN"
    echo "Try building first or specify --bin /path/to/QGroundControl"
    exit 2
fi

# Find running QGroundControl processes (exclude grep and this script)
mapfile -t PGIDS < <(pgrep -a -f QGroundControl | awk '{print $1}' || true)

if [[ ${#PGIDS[@]} -gt 0 ]]; then
    echo "Found ${#PGIDS[@]} running QGroundControl process(es): ${PGIDS[*]}"
    if $NO_KILL; then
        echo "--no-kill specified; aborting to avoid interfering with existing instance."
        exit 3
    fi

    if $ASK_KILL; then
        read -p "Kill these processes and continue? [y/N]: " resp
        resp=${resp:-N}
        if [[ "$resp" != "y" && "$resp" != "Y" ]]; then
            echo "Aborted by user."; exit 4
        fi
    fi

    echo "Killing existing QGroundControl processes..."
    # Try graceful kill first
    for pid in "${PGIDS[@]}"; do
        kill "$pid" || true
    done
    sleep 1
    # Force kill remaining
    mapfile -t STILL < <(pgrep -a -f QGroundControl | awk '{print $1}' || true)
    if [[ ${#STILL[@]} -gt 0 ]]; then
        echo "Force killing remaining processes: ${STILL[*]}"
        for pid in "${STILL[@]}"; do
            kill -9 "$pid" || true
        done
    fi
    sleep 0.5
fi

# Launch the binary in background and stream logs to terminal
echo "Starting QGroundControl: $BIN"
"$BIN" "$@" &
QPID=$!

# Give it a little time to start and detect startup errors
sleep 2
if ! kill -0 "$QPID" 2>/dev/null; then
    echo "QGroundControl failed to start (process died). Check logs above."; exit 5
fi

# Attach to the process output by tailing its log if present, otherwise wait interactively
# If users have a config path with logs, we could tail that; for now just wait and forward signals.

trap 'echo "Stopping QGroundControl (pid $QPID)..."; kill -TERM "$QPID" 2>/dev/null || true; wait "$QPID"; exit' INT TERM

# Wait for the process to exit
wait "$QPID"
EXIT_CODE=$?

echo "QGroundControl exited with code $EXIT_CODE"
exit $EXIT_CODE
