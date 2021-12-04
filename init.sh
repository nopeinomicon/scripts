#!/bin/sh
scriptdir=$(dirname "$(realpath "$0")");
. $scriptdir/image/screenshot.sh;
. $scriptdir/utils/shellutils.sh;
. $scriptdir/utils/pathutils.sh;
. $scriptdir/utils/getapps.sh;
. $scriptdir/utils/function/embedfunction.sh;