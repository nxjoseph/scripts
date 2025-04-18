#!/bin/csh

set portsf="/usr/ports/ports"
set portsdir="/usr/ports"
set maintainer="nxjoseph@protonmail.com"
set pureports="$portsdir/pure-ports"

if ( -d "$portsdir" ) then
	cd "$portsdir"
	set curdir=`pwd`
	if ( "$curdir" == "$portsdir" ) then
		if ( ! -f "$portsf") then
			touch 2 >& /dev/null "$portsf"
			if ( "$status" != 0 ) then
				echo "You probably don't have permission to create $portsf file"
				exit 1
			endif
		endif
		find . -type f -mindepth 3 -maxdepth 3 -iname makefile -exec grep -i "maintainer.*$maintainer" {} + >& $portsf
		if ( ! -f "$pureports") then
			touch 2 >& /dev/null "$pureports"
			if ( "$status" != 0 ) then
				echo "You probably don't have permission to create $pureports file"
				exit 1
			endif
		endif
		if ( -f "$portsf" ) then
			cat "$portsf" | awk -F'/' '{print $2"/"$3}' | awk -F':' '{print $1}' >& $pureports
			if ( "$status" != 0 ) then
				echo "You probably don't have permission to create/read $portsf file"
				exit 1
			endif
		else
			echo "$portsf file not found"
			exit 1
		endif
		if ( -f "$pureports" ) then	
			set portcount=`cat $pureports | wc -l`
			if ( "$portcount" >= 1 ) then
				echo "You have $portcount ports at total! Congratz!"
			else
				echo "Oh no! You don't have any ports :("
			endif
			if ( "$status" != 0 ) then
				echo "You probably don't have permission to create/read $pureports file"
				exit 1
			endif
		else
			echo "$pureports file not found"
			exit 1
		endif
	endif
else
	echo "could not found ports tree"
	exit 1
endif

if ( -f "$pureports" && -f "$portsf" ) then
	rm -f "$pureports" 2>& /dev/null
	rm -f "$portsf" 2>& /dev/null
	if ( "$status" != "0" ) then
		echo "You probably don't have permission to remove $pureports & $portsf files"
		echo "You need to manually delete them or run the script with privileges"
		exit 1
	else
		echo "deleted $pureports & $portsf file"
	endif
endif

exit 0
