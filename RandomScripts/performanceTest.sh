#!/bin/bash
set -ue

convTime(){

	time=$(($1/1000000000))
	time=`date -d @"$time"`
	echo -n "$time"

}

startTime=`date +"%s%N"`

echo "$@" | bash

endTime=`date +"%s%N"`
totalTimeNano=$(($endTime-$startTime))
startTime=`convTime $startTime`
endTime=`convTime $endTime`

echo "[$1]
start_time = $startTime
end_time = $endTime
total_time_nano_seconds = $totalTimeNano"
