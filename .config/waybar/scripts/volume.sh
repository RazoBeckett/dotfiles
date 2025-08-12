#!/usr/bin/env bash
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f", $2 * 100}')
mute=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o '\[MUTED\]')

if [ "$mute" = "󰝟  --\n" ]; then
    printf "󰝟  --\n"  # Muted icon + no volume
else
    printf "  %02d\n" "$volume"
fi
