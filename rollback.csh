#!/bin/csh

echo "Snapshot to rollback to: "
set rollback2 = $<
if ( "$rollback2" == "" ) then
	echo "You didn't give snapshot to rollback to, exiting..."
	exit 1
else
	foreach zf ( `zfs list -rH -o name -t filesystem zroot` )
		zfs rollback $zf@$rollback2
	end
	echo "Rollback is successful."
endif

exit 0
