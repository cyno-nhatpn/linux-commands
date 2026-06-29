#!/bin/bash

# ── config ────────────────────────────────────────────
REMOTE_IP="127.0.0.1"
SSH_PORT=22
REMOTE_USER="root"
SRC="/www/wwwroot/"
DEST="/var/www/"
EXCLUDES=(
    --exclude='.git/'
    --exclude='cache/'
    --exclude='phpmyadmin/'
)
RETRY_DELAY=10
# ──────────────────────────────────────────────────────

run_rsync() {
    rsync -avz -P -e "ssh -p $SSH_PORT" "${EXCLUDES[@]}" "$REMOTE_USER@$REMOTE_IP:$SRC" "$DEST"
}

if [[ "$1" == "-l" || "$1" == "--loop" ]]; then
    while true; do
        run_rsync
        EXIT=$?
        if [ $EXIT -eq 0 ]; then
            echo "rsync completed successfully."
            break
        fi
        echo "rsync failed (exit $EXIT), retrying in ${RETRY_DELAY}s..."
        sleep $RETRY_DELAY
    done
else
    run_rsync
fi
