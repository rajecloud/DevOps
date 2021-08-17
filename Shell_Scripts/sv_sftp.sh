#! /bin/bash

script_name=${0##*/}
script_name=${script_name%.sh}
mount="/cardgen"
pulseroot="/cardgen/sftp"
pulsedir="pulse-sftp"
svroot="/cardgen/nas"
svdir="pulse_to_bo"
date="$(date -d "1 day ago" '+%y%m%d')"
file=$(ls $pulseroot/$pulsedir | grep -c "D$date")
fromemail=""
clientemail=""
owneremail=""
output="$pulseroot/$pulsedir/output.txt"
format="ASCII"
backup="pulse_files"
zip_source_name="pulse.reports.zip"
new_zip_source_name="pulse-to.reports-$date.zip"
pulsesent="/pulse_files/sentfiles"
pulsereport="/pulse_files/reportfiles"
pulsedata="/pulse_files/datafiles"
newdate="$(date +%d-%m-%Y)_files"
olddate="$(date -d "1 day ago" '+%d-%m-%y')"

#######################################################################################

if [ ! -e ${mount} ] ; then

	echo "EFS Mount Point $mount not mounted yet on this node"
	exit 1
else

	x=$(ls $mount | grep sftp)

	if [[ $x != "sftp" ]] ; then

		echo "$pulseroot directory is not available"
		logger "${script_name}: Error - \"${pulseroot}\" is not available on \"${mount}\" directory, Manual intervention required"
		exit 1
	else
		y=$(ls $pulseroot | grep $pulsedir)

		if [[ $y != "$pulsedir" ]] ; then

			echo "$pulsedir under $pulseroot is not available to transfer the files"
			logger "${script_name}: Error - \"${pulsedir}\" is not available on \"${mount}\" directory, Manual intervention required"
			exit 1
		fi
	fi
fi

#########################################################################################

if [ $file -eq 0 ] ; then

	echo "There is no files loaded into the Pulse directory ($pulseroot/$pulsedir) for $olddate, hence sending the email and exiting the script"
	echo "Cannot find any files wrt date $olddate on Pulse directory ($pulseroot/$pulsedir)." | mailx -s "Pulse to SV Status for $olddate - FAILURE" -r $fromemail $owneremail

	logger "${script_name}: Error - Not find any files wet to date $olddate on \"${pulsedir}\" directory, Manual intervention required"

	exit 1

fi

###########################################################################################

sudo mkdir -p $pulsereport/$newdate $pulsesent/$newdate $pulsedata
sudo touch $output && sudo chmod 666 $output
sudo mv $pulseroot/$pulsedir/D$date*.SENT $pulsesent/$newdate
cd $pulseroot/$pulsedir/
file D$date* > $output

while read line;

do 
	z=$(echo $line)

	if [[ $z == *"$format"* ]] ; then

		a=$(echo $z | awk '{print $1}')
		b=$(echo $a | cut -f1 -d":")

		sudo mv $pulseroot/$pulsedir/$b $pulsereport/$newdate
	fi

done < $output

cd $pulsereport/$newdate && sudo zip -r $pulsereport/$zip_source_name D$date*

w=$(ls $pulsereport | grep -c $zip_source_name)

if [ "$w" -eq 0 ] ; then

	echo "Zip file creation failed to send reports attachment email, manual intervention required"
	echo "Zip file creation has been failed with some issues and mail not send to CBW with attachments, manual intervention required and script execution stopped." | mailx -s "Pulse to SV - Zip creation failed for attachment - FAILURE" -r $fromemail $owneremail

	logger "${script_name}: Error - Zip creation failed and mail not send with attachments, Manual intervention required"
	exit 1

else
	cd $pulsereport

	echo "$zip_source_name has been attached." | mailx -s "Copy of pulse-to-cbw reports. $olddate : ${zip_source_name}" -A $zip_source_name -r $fromemail $clientemail

	sudo mv $pulsereport/$zip_source_name $pulsereport/$new_zip_source_name

	sudo rm -rf $output $pulsereport/$newdate
fi

#################################################################################################


sudo cp -R $pulsesent/$newdate/D$date.*.FILEOUTA*.SENT $pulseroot/$pulsedir/

q=$(ls $pulseroot/$pulsedir | grep -c "FILEOUTA")

if [ $q -eq 0 ] ; then

	echo "Not found any data files for the date $date on pulse directory, hence sending the email"

	echo "Data files missing wrt date $olddate on Pulse directory ($pulseroot/$pulsedir), manual intervention required." | mailx -s "Pulse to SV - Data Files Missing for $olddate - FAILURE" -r $fromemail $owneremail

	logger "${script_name}: Error - No data files has been loaded on yesterday's date on \"${pulseroot}\" directory, Manual intervention required"

	exit 1

else

	#sudo cp -R $pulseroot/$pulsedir/D$date* $svroot/$svdir/
	sudo mv $pulseroot/$pulsedir/D$date* $svroot/$svdir/

	echo "All the data files wrt $olddate has been moved over to $svroot/$svdir from $pulseroot/pulsedir for sv process"

	echo "Processed the data files for the date $olddate from Pulse directory ($pulseroot/$pulsedir) to SV directory ($svroot/$svdir) without any issue." | mailx -s "Pulse to SV Status $olddate - SUCCESS" -r $fromemail $owneremail

fi

#sudo mv $pulseroot/$pulsedir/D$date* $pulsedata/ && cd $pulsedata

#sudo tar czf ${olddate}-data-files.tar.gz * && sudo rm -rf D$date*

#########################################################################################

if [ -e $pulsesent ] ; then

	cd $pulsesent/$newdate && sudo tar czf $pulsesent/${olddate}-sent-files.tar.gz *

	sudo rm -rf $pulsesent/$newdate  

	logger "${script_name}: All the files movements done without any issue, script reached end to finish the execution"

fi

echo "File Process between Pulse to SV has been completed and Backup has been taken and stored on $backup for reference..!"

###############################################################################################

