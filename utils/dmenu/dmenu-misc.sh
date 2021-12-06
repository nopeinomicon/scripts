#!/bin/sh
getmenu() {
    if command -v bemenu >/dev/null; then
        printf "bemenu"
    elif command -v bemenu >/dev/null; then
        printf "dmenu"
    fi
}