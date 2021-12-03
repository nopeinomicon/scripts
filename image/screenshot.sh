#!/bin/sh
screenshot() {
    filename="$HOME/Pictures/Screenshots/screenshot-$(date +\%Y\%m\%d\%H\%M).png";
    if  [ $XDG_SESSION_TYPE = "wayland" ]
        then
            out=$(grimshot save area "$filename");
            if [ -z "${out##*"selection cancelled"*}" ]
            then
                return 1;
            fi
        else # assume an Xorg environment as a safe option if Wayland not detected
            scrot -s "$filename";
	fi
    # Preview captured screenshot in kitty terminal
    # TODO: Add other preview method support
    if  [ $TERM = "xterm-kitty" ]
    then
        kitty +kitten icat "$filename";
    # WIP method to preview using ueberzug on Xorg
    elif [ $XDG_SESSION_TYPE = "x11" ] 
    then
        echo "{\"action\": \"add\", \"identifier\": \"img\", \"x\": 0, \"y\": 0, \"path\": \"$filename\"}" | ueberzug layer -p json;
    fi
	echo "Image saved to $filename";
	selection=$(printf "Yes\nNo" | bemenu -p "Copy to clipboard? [y/N]");
	selection=$(echo "$selection" | cut -c1-1); # Cut input to first character
    selection=$(echo "$selection" | tr '[:upper:]' '[:lower:]'); # Force lowercase
	if	[ $selection = "y" ]
	then
        if  [ $XDG_SESSION_TYPE = "wayland" ]
        then
            wl-copy < "$filename";
        else # assume an Xorg environment as a safe option if Wayland not detected
            xclip -i < "$filename";
		fi
		echo "Image copied to clipboard.";
	fi
}