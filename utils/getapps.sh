#!/bin/sh
getapps() {
    applist=""
    getpathdirs | while IFS= read -r directory; do
        find "$directory" -maxdepth 1 -perm -111 -type f | while IFS= read -r execfile; do
            applist="$applist\n$(trim_filepath "$execfile")"
        done
    done
    echo "$applist" | sort -u
}
getfunctions() {
    if command -v declare >/dev/null; then
        declare -f | awk -v RS='\n}\n' '/[^:cntrl::space:]*\(\)[:cntrl::space:]*/ {print $1}' | sed "/^_/D" | sed "s/[()]*/""/g" | sed "/[\[\]+(){}=%\;~$]/D" | sed "/function.*/D" | sed "/local.*/D" | sed "/^$/d" | sort -u
    elif command -v typeset >/dev/null; then
        typeset -f | awk -v RS='\n}\n' '/[^:cntrl::space:]*\(\)[:cntrl::space:]*/ {print $1}' | sed "/^_/D" | sed "s/[()]*/""/g" | sed "/[\[\]+(){}=%\;~$]/D" | sed "/function.*/D" | sed "/local.*/D" | sed "/^$/d" | sort -u
    else
        echo "This command is incompatible with this shell! Use more featureful shell like ksh, bash, zsh, etc."
        return 1
    fi
}
