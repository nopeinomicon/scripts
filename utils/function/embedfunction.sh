#!/bin/sh
getfunctionnames() {
    if command -v declare >/dev/null; then
        declare -f | awk -v RS='\n}\n' '/[^:cntrl::space:]*\(\)[:cntrl::space:]*/ {print $1}' | sed "/^_/D" | sed "s/[()]*/""/g" | sed "/[\[\]+(){}=%\;~$]/D" | sed "/function.*/D" | sed "/local.*/D" | sed "/^$/d" | sort -u
    elif command -v typeset >/dev/null; then
        typeset -f | awk -v RS='\n}\n' '/[^:cntrl::space:]*\(\)[:cntrl::space:]*/ {print $1}' | sed "/^_/D" | sed "s/[()]*/""/g" | sed "/[\[\]+(){}=%\;~$]/D" | sed "/function.*/D" | sed "/local.*/D" | sed "/^$/d" | sort -u
    else
        echo "This command is incompatible with this shell! Use more featureful shell like ksh, bash, zsh, etc."
        return 1
    fi
}
getfunction() {
    if command -v declare >/dev/null; then
        declare -f "$@";
    elif command -v typeset >/dev/null; then
        typeset -f "$@"
    else
        echo "This command is incompatible with this shell! Use more featureful shell like ksh, bash, zsh, etc."
        return 1
    fi
}
embedfunction () {
    if [ "$(echo "$arg" | cut -c1-2)" = "-h" ]; then
        echo "embedfunction [-h] [DEPENDENCY_LIST] [FUNCTION_NAMES]"
        echo "DEPENDENCY_LIST: File which contains the list of functions and their dependencies. An example file should have come with the script."
        echo "FUNCTION_NAME: Names of functions to be embeded, comma-seperated"
        return 0;
    elif [ -z "$1" ] || [ -z "$2" ]; then
        echo "Invalid arguments!"
        return 1;
    fi
    needed_functions=""
    maindepline=$(grep "$2:" < "$1")
    if [ -n "$maindepline" ]; then
        needed_functions=$(echo "$maindepline" | awk '{print $2}' | sed 's/,/ /g')
        echo "$maindepline" | awk '{print $2}' | sed 's/,/\n/g' | while read -r reqfunc; do
            depline=$(grep "$reqfunc:" < "$1")
            if [ -n "$depline" ]; then
                needed_functions="$needed_functions $(echo "$depline" | awk '{print $2}' | sed 's/,/ /g')"
            fi
        done
    fi
    needed_functions="$needed_functions $(echo "$2" | sed 's/,/ /g')"
    echo "#!$SHELL"
    getfunction $(echo "$needed_functions")
    echo "$2"
}