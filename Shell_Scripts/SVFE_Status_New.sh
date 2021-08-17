#! /bin/bash

script_name=${0##*/}
script_name=${script_name%.sh}
ROOT="/home/svfe/Data"
Log="/home/svfe/Data/Logs"
Home="/home/svfe"
FILE="_status_"$(date +"%Y_%m_%d_%I_%M_%p")""
Output="/home/svfe/Data/_filter1.txt"
Json="/home/svfe/Data/output.json"
uptime="$(awk '{print $1*1000}' /proc/uptime)"
status="Ok"
ServiceName="SVFE"
JSON_FMT='{"status":"%s","serviceName":"%s","sysInfo":{"uptime":%s}} \n'
cname="ystack"
nats_url=""
#topic="health.svfe"


###########################################################

if [ ! -e ${ROOT} ] ; then

	mkdir -p $(pwd)/Data
else
	echo "Directory already exists, hence moving for next execution"
fi

##########################################################

if [ ! -e ${Log} ] ; then

	mkdir -p $(pwd)/Data/Logs
else
	echo "Log directory already exists, hence moving for next execution"
fi

#################################################

if [ -e ${Home} ] ; then

	svstat > $Log/$FILE

	sed -i '/tcpcomms[1-8]/d' $Log/$FILE

	egrep 'epayint|tcpcomm|stdauth' $Log/$FILE > $ROOT/_filter.txt

	gawk '{ print $1 "    " $2}' $ROOT/_filter.txt > $Output

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

	if [[ $y != "RUNNING" ]] ;

	then

		status="NotOk"

	fi

done < $Output

########################################################

#Creating the Json string output for heart beat use case

message=$(printf "$JSON_FMT" "$status" "$ServiceName" "$uptime")

#################################################

#Sending Heart beat to monitoring dashboard

./np -cluster $cname -url $nats_url -topic "health.svfe" -msg $message

########################################################

#Delete the created directory to free up space

rm -rf $ROOT

######################################################