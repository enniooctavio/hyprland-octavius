#!/bin/bash

DELAY=${1:-0}

if [ "$DELAY" -gt 0 ]; then
    sleep "$DELAY"
fi

grim -g "$(slurp)" /tmp/screenshot_active.png && swappy -f /tmp/screenshot_active.png
