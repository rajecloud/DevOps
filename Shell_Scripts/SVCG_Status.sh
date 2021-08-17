#! /bin/bash

script_name=${0##*/}
script_name=${script_name%.sh}
ROOT="/home/smartcg/Data"
#Log="/home/svfe/Data/Logs"
Home="/home/smartcg"
#FILE="_status_"$(date +"%Y_%m_%d_%I_%M_%p")""
Output="/home/smartcg/Data/_filter.txt"
Json="/home/smartcg/Data/output.json"
uptime="$(awk '{print $1*1000}' /proc/uptime)"
status="Ok"
ServiceName="SVCG"
JSON_FMT='{"status":"%s","serviceName":"%s","sysInfo":{"uptime":%s}} \n'
cname="ystack"
nats_url=""
#topic="health.svcg"


if [ ! -e ${ROOT} ] ; then

	mkdir -p $(pwd)/Data
else
	echo "Directory already exists, hence moving for next execution"
fi

#########################################

if [ -e ${Home} ] ; then

	sh ./svcg status | grep Status > $Output

else

	echo "Script is not executing with required user permission, hence stopping the script"
	exit 
fi

########################################################

#Confirming the application status

while read line;

do 
	y=$(echo $line | awk '{print $2}')
	echo $y

	if [[ $y != "OK" ]] ; then

		status="NotOk"
	fi

done < $Output

########################################################

#Creating the Json string output for heart beat use case

message=$(printf "$JSON_FMT" "$status" "$ServiceName" "$uptime")

#################################################

#Sending Heart beat to monitoring dashboard

./np -cluster $cname -url $nats_url -topic "health.svcg" -msg $message

########################################################

#Delete the created directory to free up space

rm -rf $ROOT

######################################################

