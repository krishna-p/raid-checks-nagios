#!/bin/bash

ware1=/opt/3ware/CLI/tw_cli
ware2=/usr/local/ysa/bin/tw_cli

if [ -f /opt/3ware/CLI/tw_cli ]; then
    control=`$ware1 show | grep -o c[0-9]`
    $ware1 info $control > /tmp/raidcheck
else
    control=`$ware2 show | grep -o c[0-9]`
    $ware2 info $control > /tmp/raidcheck
fi

grep -iq 'ERROR' /tmp/raidcheck

if [ $? -eq 0 ]; then
    echo  "CRITICAL: There is a device error in raid array"
    exit 2
fi

grep -iq 'REBUILDING' /tmp/raidcheck
    
if [ $? -eq 0 ]; then
      echo  "WARNING: RAID rebuild in progress"
    exit 1
fi

egrep -iq 'DEGRADED|OFFLINE' /tmp/raidcheck

if [ $? -eq 0 ]; then
      echo  "CRITICAL: The RAID array is degarded"
    exit 2
fi

echo "OK: RAID array fine"

