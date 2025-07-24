#!/usr/bin/env bash

# Usage: web2app.sh <url> <name> <class>
URL="$1"
NAME="$2"
CLASS="$3"

if [ -z "$URL" ] || [ -z "$NAME" ] || [ -z "$CLASS" ]; then
    echo "Usage: $0 <url> <name> <class>"
    exit 1
fi

ARGS=("--new-window")

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    ARGS+=("--ozone-platform=wayland")
fi

ARGS+=(
    "--app=$URL"
    "--name=$NAME"
    "--class=$CLASS"
)

exec chromium "${ARGS[@]}"
