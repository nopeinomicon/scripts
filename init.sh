#!/bin/sh
scriptdir=$(dirname "$(realpath "$0")");
export PATH="$PATH:$scriptdir/file"
export PATH="$PATH:$scriptdir/image"
export PATH="$PATH:$scriptdir/utils"