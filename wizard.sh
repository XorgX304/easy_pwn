#!/bin/bash
# Sailfish OS easy_pwn
#
# Copyright (C) 2020 <Giuseppe `r3vn` Corti>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# check privileges
if [ "$EUID" -ne 0 ]
then 
	echo "[!] run as root"
	exit 1
fi

# check args
if [ "$#" -lt 1 ] 
then
	echo "[!] usage: $0 [kalifs path]" 
	exit 1
fi

# set variables
WIZ_PATH=`readlink -f "$0"`
PWN_DIR=`dirname "$WIZ_PATH"`
PWN_SCRIPT=$PWN_DIR/easy_pwn.sh
CHROOT_PATH="$1"

# import default settings
. $PWN_DIR/settings.sh

INPUT_LOOP(){
	read -p "[>] " SELECTION

	case "$SELECTION" in
		1)
			# start chroot desktop
			echo "[?] select desktop orientation (default portrait): [p]ortrait, [l]andscape: "
			read DESKTOP_ORIENTATION

			if [ "$DESKTOP_ORIENTATION" == "l" ]
			then
				. $PWN_SCRIPT desktop $CHROOT_PATH --landscape
			else
				. $PWN_SCRIPT desktop $CHROOT_PATH
			fi
		;;  
		2) . $PWN_SCRIPT shell $CHROOT_PATH	;;
		3) . $PWN_SCRIPT ssh $CHROOT_PATH ;;
		4) . $PWN_SCRIPT bettercap $CHROOT_PATH	;;
		5) . $PWN_SCRIPT update $CHROOT_PATH ;;
		6) . $PWN_SCRIPT kill $CHROOT_PATH ;;
		7) . $PWN_SCRIPT quit $CHROOT_PATH ;;
		00) HELP_MSG ;;
		*)
			echo "[!] invalid selection"
			exit 1
	esac
}

HELP_MSG(){
	echo "[+] Available options:"
	echo "   - 1 kali desktop"
	echo "   - 2 kali shell"
	echo "   - 3 ssh server"
	echo "   - 4 bettercap webui"
	echo "   - 5 update easy_pwn"
	echo "   - 6 kill all chroot processes"
	echo "   - 7 umount and quit (experimental)"
	echo "   - 00 this message"
}

echo "  ___  __ _ ___ _   _       _ ____      ___ __"
echo " / _ \\/ _\` / __| | | |     | '_ \\ \\ /\\ / / '_ \\ "
echo "|  __/ (_| \\__ \\ |_| |     | |_) \\ V  V /| | | |"
echo " \\___|\\__,_|___/\\__, |     | .__/ \\_/\\_/ |_| |_|"
echo "                 __/ |_____| |"             
echo "                |___/______|_|  ($PWN_VERSION) "               
echo "	"

HELP_MSG

while :
do
	INPUT_LOOP
done

