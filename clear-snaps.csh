#!/bin/csh

echo "Pool to operate on: "
set pool = $<
echo "Snapshot to keep: "
set keep = $<

if ( "$pool" == "" || "$keep" == "" ) then
	echo "Required variables aren't defined"
	exit 1
endif

foreach snap ( `zfs list -H -o name -t snap -r $pool | grep -vxE ".*$keep"` )
	if ( "$status" != 0 ) then
		echo "Error destroying snapshot $snap"
		exit 1
	endif
	zfs destroy -rv $snap
end

if ( "$pool" == "zroot" ) then
	set clean=`zfs list -t snap -r $pool | grep clean`
	if ( "$status" != 0 ) then
		echo "Clean jails not found, re-creating them..."
		foreach jail ( `zfs list -H -o name -r $pool/poudriere/jails | sed '1d' | cut -c 23-` )
			if ( "$status" != 0 ) then
				echo "Error creating clean jail $jail"
				exit 1
			endif
			zfs snapshot $pool/poudriere/jails/$jail@clean
		end
	else
		echo "Clean jails already found, not creating them."
	endif
endif

exit 0
