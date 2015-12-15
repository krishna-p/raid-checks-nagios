#!/bin/sh

set -e

if [ ! -f /usr/StorMan/arcconf ]; then
        echo "CRITICAL: /usr/StorMan/arcconf not found"
        exit 2
fi

/usr/StorMan/arcconf getconfig 1 ld | grep -i status | while read ld
do
        optild=`echo $ld |  awk '{print $NF}'`
        if [ ! "$optild" = "Optimal" ]; then
                echo "CRITICAL: One of the logical device is not Optimal"
                exit 2
        fi
done

/usr/StorMan/arcconf getconfig 1  pd  | grep -w  State | grep -iv power  | while read pd
do
        optipd=`echo $pd |  awk '{print $NF}'`
        if [ ! "$optipd" = "Online" ]; then
                echo "CRITICAL: One of the physical device is not Optimal"
                exit 2
        fi
done


/usr/StorMan/arcconf getconfig 1  al | grep -w S.M.A.R.T |grep -v warnings  | while read  smart
do
        optismart=`echo $smart |  awk '{print $NF}'`
        if [ ! "$optismart" = "No" ]; then
                echo "CRITICAL: One of the physical device has got SMART error"
                exit 2
        fi
done

/usr/StorMan/arcconf getconfig 1  al | grep "Controller Status"  | while read  contr
do
        opticontr=`echo $contr |  awk '{print $NF}'`
        if [ ! "$opticontr" = "Optimal" ]; then
                echo "CRITICAL: Controller not showing Optimal status"
                exit 2
        fi
done


echo "OK: Controller, Logical devices and Physical devices fine and no SMART errors"

