#!/bin/sh
getshell() {
    pgrep -l sh -P $PPID | sed 1q | awk '{print $2}'
}