#!/bin/bash
set -ue
powerconsumption=`cat /sys/class/power_supply/BAT0/power_now`
echo $(( $powerconsumption / 1000000 )) 
