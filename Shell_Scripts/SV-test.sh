#! /bin/bash

HOST1="svfe"
Host2=svfm
ROOT="/home/yanadmin/Data"
Log_Dir="/home/yanadmin/Data/Logs"
HOME="/home/svfe/"
FILE="status_"$(date +"%Y_%m_%d_%I_%M_%p")""
Filter_File=$ROOT/Filter/file.txt
Filter_File1=$ROOT/Filter/file1.txt
Filter_New_File=$ROOT/Filter/filter.txt
Host_Name="$(hostname)"
Json="$ROOT/output.json"
#arg1="$1"
#arg2="$2"

#mkdir $ROOT/Filter

#######################################################

if [ ${Host_Name} == master-node ] ; then

	echo "Location is correct, hence executing the script"
else
	echo "Not a correct location to run the script"
	exit
fi

#########################################################


if [ ! -e ${Log_Dir} ] ; then

	mkdir -p $(pwd)/Data/Logs
else
	echo "$Log_Dir directory is ready to store log files"
fi

##########################################################

echo "Accessing the sv front end to get the status"

ssh -t $HOST1 sudo su - svfe svstat > $Log_Dir/$FILE.log

#
	grep -F "tcpcomms" $Log_Dir/$FILE.log > $Filter_File
	grep -F "stdauth" $Log_Dir/$FILE.log >> $Filter_File


########################################################3

#if [ ${arg2} == "$2" ]; then

	

#fi

gawk '{ print $1 "      " $2}'  $Filter_File > $Filter_File1
#awk -F '' '/tcpcomms/ || /stdauth/' $Log_Dir/$FILE.log > $Filter_File

#awk -F '' '{ print $1, $2}' || /tcpcomms/ || /stdauth/' $Log_Dir/$FILE.log > $Filter_File


################################################

if [ -e ${ROOT} ] ; then 

	#awk -F '' 'NR==7 || NR==8 || /tcpcomms/ || /stdauth/' $Log_Dir/$FILE.log > $Filter_File
	#awk -F '' '/tcpcomms/ || /stdauth/' $Log_Dir/$FILE.log > $Filter_File


	ssh -t $HOST1 uptime > $Filter_New_File


	awk ' BEGIN { print "{\n " "  \"svfe_status\" : \""  "\" \n" " "["  ; }  { print " {\n" "   \"serviceName\" : \""   $1  "\",\n"  "   \"status\" : \""  $2 "\"\n"  "  }" }   END { print "" } ' $Filter_File1 > $Json

	awk ' BEGIN { print "\n " "[" "\n " "sysinfo" ; }  { print " {\n" "   \"uptime\" : \""   $3 "\n" $4 "\",\n" "   \"services\" : \""    "\"\n" " }" "\n" "]" }   END { print "}" } ' $Filter_New_File >> $Json 

fi

#######################################################

#echo "*****************SVFM Status******************" >> $Filter_File

#ssh -t $Host2 sudo su - svfm ./svfm status | tail -n +2 >> $Filter_File

Json string copy it not file.

 
