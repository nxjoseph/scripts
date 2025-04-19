#!/bin/csh

set id=`id -u`
set portsdir="/usr/ports"
set maintainer="nxjoseph@protonmail.com"
set pureports="$portsdir/pure-ports"
set portsf="$portsdir/ports"
set destdir="/home/yusuf/Documents/yusuf-ports-overlay"

if ( "$id" != "0" ) then
	echo "please run this as root"
	exit 1
endif

if ( -d "$portsdir" ) then
	cd "$portsdir"
	set curdir=`pwd`
	if ( "$curdir" == "$portsdir" ) then
		find . -type f -mindepth 3 -maxdepth 3 -iname makefile -exec grep -i "maintainer.*$maintainer" {} + >& "$portsf"
		cat "$portsf" | awk -F'/' '{print $2"/"$3}' | awk -F':' '{print $1}' > & "$pureports"
		foreach dir (`cat $pureports`)
   		# Extract the first directory name
   		set first_dir = `echo "$dir" | cut -d'/' -f1`
   		
   		# Create the full destination path
   		set destination_path = "$destdir/$first_dir"
   		
   		# Create the destination directory if it doesn't exist
   		mkdir -p "$destination_path"
   		
   		# Copy the directory
   		cp -r "$dir" "$destination_path"
   		
   		echo "Copied $dir to $destination_path"
		end		
	endif
else
	echo "could not found ports tree"
	exit 1
endif

if ( -f "$pureports" ) then
	rm -f "$pureports"
else
	echo "$pureports not found"
	exit 1
endif

if ( -f "$portsf" ) then
	rm -f "$portsf"
else
	echo "$portsf not found"
	exit 1
endif

exit 0
