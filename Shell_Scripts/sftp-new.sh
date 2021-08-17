#!/bin/bash

script_name=${0##*/}
script_name=${script_name%.sh}
bankusername=""
visausername=""
bankname="$bankusername"
efsMount="/data"
bankdir="$efsMount/$bankname"
dir1="incoming"
dir2="outgoing"
config="/etc/ssh/sshd_config"
file="$(cat /etc/passwd | grep -c "$bankusername")"
archive="archive"


if [ $file -eq 0 ] ; then

	read -s -p "Enter $bankusername password : " password
	sudo useradd -m -p $(openssl passwd -crypt $password) $bankusername

else

	echo "$bankusername already exists"
	logger "${script_name}: Update - \"${bankusername}\" already exists, skipping the creation step"
	
fi


#########################################################################

if [ ! -e ${efsMount} ] ; then

	echo "Mount $efsMount Folder is not available"
	logger "${script_name}: Error - \"${efsMount}\" is not mounted yet, Manual intervention required"
	exit 0
else
	sudo mkdir -p $bankdir
	x=$(ls | grep $bankusername)
	echo $x

	if [ $x -ne 0 ] ; then

		sudo mkdir -p $bankdir/$bankusername/$dir1 $bankdir/$bankusername/$dir2
		#sudo mkdir -p $bankusername/$dir2
		sudo chmod -R 755 $bankdir
		sudo chown $bankusername:$bankusername $bankdir/$bankusername/$dir1 $efsMount/$bankusername/$dir2
		#sudo chown $bankusername:$bankusername $efsMount/$bankusername/$dir2

		echo "$bankusername directory creation and permission done"
	fi

fi

#########################################################################

if [ -e $bankdir ] ; then

	sudo mkdir -p $bankdir/$archive && sudo chmod -R 755 $bankdir/$archive
fi

############################################################################

echo "All the directory creation and permission has been done, Hence Moving to update the $config file"

if [ -f "$config" ] ; then

sudo bash -c "echo '
Match User $bankusername
ForceCommand internal-sftp
PasswordAuthentication yes
ChrootDirectory $bankdir/$bankusername
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no' >> $config" 

echo "Config file has been written"

else

	echo "Can't found config file"
	logger "${script_name}: Error - \"${config}\" file not found, Manual intervention required"
	exit 0

fi

echo "$config file updated and restarting the sshd service"

sudo systemctl restart sshd

echo "Restart completed and sftp visa setup for $bankusername bank is ready"

#########################################################################

