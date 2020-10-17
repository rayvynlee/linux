#!/bin/bash
for pidproxy in `screen -ls | grep ".proxy" | awk {'print $1'}`; do
	screen -r -S "$pidproxy" -X quit
done

port="8010"
procss=`netstat -nplt |grep 'python' | awk {'print $4'} | cut -d: -f2 |xargs`
check=`yum info screen | grep Repo | awk '{ print $3 }'`
if [ "$check" == "installed" ]; then
	if [ -n "$procss" ]; then
		echo "Socks Proxy already Running"
	else
		screen -dmS proxy python /usr/local/sbin/proxy.py $port
		echo "Socks Proxy has been Started"
	fi
else
	yum -y install screen >/dev/null 2>&1
	sleep 3
	screen -dmS proxy python /usr/local/sbin/proxy.py $port
	echo "Socks Proxy Started"
fi

