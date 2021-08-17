#! /bin/bash

script_name=${0##*/}
script_name=${script_name%.sh}
ROOT="/home/svfe/Data"
Log="/home/svfe/Data/Logs"
Home="/home/svfe"
FILE="_status_"$(date +"%Y_%m_%d_%I_%M_%p")""
Output="/home/svfe/Data/_filter1.txt"
Json="/home/svfe/Data/output.json"

if [ ! -e ${ROOT} ] ; then

	mkdir -p $(pwd)/Data
else
	echo "Directory already exists, hence moving for next execution"
fi

#########################################

if [ ! -e ${Log} ] ; then

	mkdir -p $(pwd)/Data/Logs
else
	echo "Log directory already exists, hence moving for next execution"
fi

#######################################

if [ -e ${Home} ] ; then

	svstat > $Log/$FILE

	egrep 'tcpcomm|stdauth' $Log/$FILE > $ROOT/_filter.txt

	gawk '{ print $1 "      " $2}' $ROOT/_filter.txt > $Output

else

	exit 
fi

#########################################

if [ -e ${Home} ] ; then

	uptime > $ROOT/_filter2.txt

	gawk '{ print $3 " " $4 }' $ROOT/_filter2.txt > $ROOT/_filter3.txt


fi

#########################################

if [ -e ${Output} ] ; then

	awk ' BEGIN { print  "svfeStatus" ":" "" "\n" " [" ; }  { print "  {\n" "   /
	 \"serviceName\" : \""   $1  "\",\n"  "    \"status\" : \""  $2 "\" \n"  "  }, " }   END { print " ] \n" } ' $Output > $Json

else

	exit 

fi

###########################################

if [ -e ${Output} ] ; then

	awk ' BEGIN { print  " [" ; }  { print "  {\n" "    \"upTime\" : \""   $1 $2 "\",\n"  "  }, " }   END { print " ] \n" } ' $ROOT/_filter3.txt >> $Json

fi

###########################################

if [ -e ${Output} ] ; then

	df -h | tail -n +2 > $ROOT/_filter3.txt

	awk ' BEGIN { print  " [" ; }  { print "  {\n" "    \"fileSystem\" : \""   $1  "\",\n"  "    \"size\" : \""  $2 "\",\n" "    \"used\" : \""   $3  "\",\n" "    \"avail\" : \""   $4  "\",\n" "    \"mountPath\" : \""   $6  "\",\n" "  }, " }   END { print " ]" } ' $ROOT/_filter3.txt >> $Json

fi
