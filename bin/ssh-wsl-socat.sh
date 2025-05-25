#!/usr/bin/env zsh

source $HOME/.zsh.d/modules/color24.zsh

SOCK="$HOME/.ssh/sock"
LOG="$HOME/.ssh/sock.log"

# Check for required tools
for cmd in socat npiperelay.exe ssh-agent.exe; do
    if ! command -v "$cmd" >/dev/null; then
        echo "Missing command: $cmd" >&2
        exit 1
    fi
done

# Clean up old socket and process
pkill -f "socat UNIX-LISTEN:$SOCK" 2>/dev/null
rm -f "$SOCK"

# Start socat in background
setsid socat UNIX-LISTEN:"$SOCK",fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent" \
    > "$LOG" 2>&1 &

# Give it a moment to start
sleep 0.2

# Verify it's working
export SSH_AUTH_SOCK="$SOCK"
if ssh-add -l >/dev/null 2>&1; then
  echo "$(color24 "#00AA88" "󱘖 ") Windows/WSL : Connected to Windows ssh-agent $SOCK"
else
    echo "❌ Windows/WSL : Failed to connect to ssh-agent via $SOCK"
    echo "Last 10 log lines:"
    tail -n 10 "$LOG"
    exit 2
fi

