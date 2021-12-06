#!/bin/ksh
runmenu() {
    selection=$(echo "$(getapps)$(getfunctionnames)" | sort -u | eval "$(getmenu)")
    $selection
}