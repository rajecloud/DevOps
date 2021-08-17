#! /bin/bash

script_name=${0##*/}
script_name=${script_name%.sh}
mount="/cardgen"
pulseroot="/cardgen/sftp"
pulsedir="pulse-sftp"
svroot="/cardgen/nas"
svdir="pulse_to_bo"
date="$(date -d "1 day ago" '+%y%m%d')"
file=$(ls $pulseroot/$pulsedir/ | grep -c "$date")
email=""
output="$pulseroot/$pulsedir/output.txt"
format="ASCII"
pulsesent="/tmp/sentfiles"
pulseascii="/tmp/asciifiles"
pulsedata="/tmp/datafiles"
newdate="$(date +%F)_files"
olddate="$(date -d "1 day ago" '+%F')"

#################################################################################################

if [ ! -e ${mount} ] ; then

	echo "EFS Mount Point $mount not mounted yet on this node"
	exit 0
else

	x=$(ls $mount | grep sftp)

	if [[ $x != "sftp" ]] ; then

		echo "$pulseroot directory is not available"
		logger "${script_name}: Error ${error_code} \"${pulseroot}\" is not available on \"${mount}\" directory, Manual intervention required"
		exit 0
	else
		y=$(ls $pulseroot | grep $pulsedir)

		if [[ $y != "$pulsedir" ]] ; then

			echo "$pulsedir under $pulseroot is not available to transfer the files"
			logger "${script_name}: Error ${error_code} \"${pulsedir}\" is not available on \"${mount}\" directory, Manual intervention required"
			exit 0
		else

			echo "Checking whether any files loaded by Pulse into this $pulseroot/$pulsedir directory"

			if [ $file -eq 0 ] ; then

				echo "No files loaded yet for the date $date on pulse directory, hence sending the email"

				echo "Cannot find any files wrt date $date on $pulseroot/$pulsedir." | mail -s "Pulse File Status - $olddate" $email

				logger "${script_name}: Error ${error_code} No files has been loaded on yesterday's date on \"${pulseroot}\" directory, Manual intervention required"
			else

				sudo cp -R $pulseroot/$pulsedir/D$date* $svroot/$svdir/
				echo "All the files wrt $olddate has been copied over to $svroot/$svdir from $pulseroot/pulsedir for sv process"
			fi
		fi
	fi
fi

#########################################################################################


sudo mkdir -p $pulseascii/$newdate $pulsesent/$newdate $pulsedata
sudo touch $output
sudo chmod 666 $output
sudo mv $pulseroot/$pulsedir/D$date*.SENT $pulsesent/$newdate
cd $pulseroot/$pulsedir/
file D$date* > $output

while read line;

do 
	z=$(echo $line)

	if [[ $z == *"$format"* ]] ; then

		a=$(echo $z | awk '{print $1}')
		b=$(echo $a | cut -f1 -d":")

		sudo mv $pulseroot/$pulsedir/$b $pulseascii/$newdate
	fi

done < $output

############################################################################################

sudo mv $pulseroot/$pulsedir/D$date* $pulsedata/

cd $pulseascii/$newdate/

sudo echo "Pulse text files has been attached for your reference" | mail -s "Pulse loaded text files - $olddate" -A D$date* $email

cd $pulseascii/$newdate

sudo tar czf $pulseascii/${olddate}-ascii-files.tar.gz *

cd $pulsesent/$newdate

sudo tar czf $pulsesent/${olddate}-sent-files.tar.gz *

sudo rm -rf $pulsesent/$newdate $pulseascii/$newdate $output

echo "File Processed between Pulse to SV has been completed and Backup of files has been taken and mail send with attachments..!"

###############################################################################################

