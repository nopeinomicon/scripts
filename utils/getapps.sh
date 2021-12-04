#!/bin/sh
getapps() {
    getpathdirs | while IFS= read -r directory; do
        find "$directory" -maxdepth 1 -perm -111 -type f | while IFS= read -r execfile; do
            echo "$(trim_filepath "$execfile")" >> .apptmp
        done
    done
    cat .apptmp | sort -u
    rm .apptmp
}