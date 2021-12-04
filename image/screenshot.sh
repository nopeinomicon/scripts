#!/bin/sh
screenshot() {
    filename="$HOME/Pictures/Screenshots/screenshot-$(date +\%Y\%m\%d\%H\%M).png"
    if [ $XDG_SESSION_TYPE = "wayland" ]; then
        out=$(grimshot save area "$filename")
        if [ -z "${out##*"selection cancelled"*}" ]; then
            return 1
        fi
    else # assume an Xorg environment as a safe option if Wayland not detected
        scrot -s "$filename"
    fi
    # Preview captured screenshot in kitty terminal
    if [ $TERM = "xterm-kitty" ]; then
        kitty +kitten icat "$filename"
    # WIP method to preview using ueberzug on Xorg
    # elif [ $XDG_SESSION_TYPE = "x11" ] && command -v ueberzug > /dev/null
    # then
    #     echo "{\"action\": \"add\", \"identifier\": \"img\", \"x\": 0, \"y\": 0, \"path\": \"$filename\"}" | ueberzug layer -p json;
    else
        selection="n"
        if command -v bemenu >/dev/null; then
            selection=$(printf "No\nYes" | bemenu -p "Show image preview? [y/N]")
        elif command -v dmenu >/dev/null; then
            selection=$(printf "No\nYes" | dmenu -p "Show image preview? [y/N]")
        else
            echo "Show image preview? [y/N]"
            read selection
        fi
        selection=$(echo "$selection" | cut -c1-1)                  # Cut input to first character
        selection=$(echo "$selection" | awk '{print tolower($0)}') # Force lowercase
        if [ $selection = "y" ]; then
            if command -v imv >/dev/null; then
                imv $filename &
            elif command -v feh >/dev/null; then
                feh $filename &
            else
                echo "Cannot find application to open preview with!"
            fi
        fi
    fi
    echo "Image saved to $filename"
    selection="n"
    if command -v bemenu >/dev/null; then
        selection=$(printf "No\nYes" | bemenu -p "Copy to clipboard? [y/N]")
    elif command -v dmenu >/dev/null; then
        selection=$(printf "No\nYes" | dmenu -p "Copy to clipboard? [y/N]")
    else
        printf "Copy to clipboard? [y/N]"
        read selection
    fi
    selection=$(echo "$selection" | cut -c1-1)                  # Cut input to first character
    selection=$(echo "$selection" | awk '{print tolower($0)}') # Force lowercase
    if [ $selection = "y" ]; then
        if [ $XDG_SESSION_TYPE = "wayland" ]; then
            wl-copy <"$filename"
        else # assume an Xorg environment as a safe option if Wayland not detected
            xclip -i <"$filename"
        fi
        echo "Image copied to clipboard."
    fi
}
