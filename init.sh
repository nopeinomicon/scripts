#!/bin/sh
scriptdir=$(dirname "$(realpath "init.sh")");
. $scriptdir/image/screenshot.sh;
. $scriptdir/utils/shellutils.sh;
. $scriptdir/utils/pathutils.sh;
. $scriptdir/utils/getapps.sh;
. $scriptdir/utils/function/embedfunction.sh;
. $scriptdir/utils/dmenu/dmenu-misc.sh;
. $scriptdir/utils/dmenu/runmenu.sh;