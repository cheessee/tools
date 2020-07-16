#!/bin/bash
date=$(date)
echo "Start check at $date"
echo "Last check at $date" > /tmp/lastCheck.log
container=$(docker ps -a | grep flow | awk '{print $1}')
logs=$(docker logs --since 1m $container)
error=$(echo $logs | grep 'UnhandledPromiseRejectionWarning: Error: ENOENT: no such file or directory,')
nerror=$(echo ${#error})
if [ ${nerror} -gt 0 ]; then
	echo "Reset flowengine"
	echo "$date : Start flowengine restart" >> /tmp/reset.log
	docker restart $container
	echo "W8ing for restart"
	sleep 15m
	echo "FlowEngine up again!"
	echo "$date FlowEngine up again!" >> /tmp/reset.log
	exit 0
fi
	exit 0
echo "Last check at $date"
