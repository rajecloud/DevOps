#!/bin/bash


script_name=${0##*/}
script_name=${script_name%.sh}
BankUsername=""
VisaBankUsername=""
VisaBankFolder=""
VisaUsername="visa"
bankname="$BankUsername"
bankname1="$VisaBankUsername"
efsMount="/data"
dir1="incoming"
dir2="outgoing"
visa="$efsMount/visa"
VisaBank="$visa/$VisaBankFolder"
#VisaNetsys="$efsMount/visa/$dir1"
config="/etc/ssh/sshd_config"
bank="$efsMount/$bankname"
file="$(cat /etc/passwd | grep -c "$BankUsername")"
archive="archive"


if [ $file -eq 0 ] ; then

	read -s -p "Enter $BankUsername password : " password
	sudo useradd -m -p $(openssl passwd -crypt $password) $BankUsername

else

	echo "$BankUsername already exists"
	
fi

########################################################################

if [ $file -eq 0 ] ; then

	sudo useradd -m -p $(openssl passwd -crypt $password) $VisaBankUsername
	sudo usermod -a -G visa $VisaBankUsername

else

	echo "$VisaBankUsername already exists"
	
fi


#########################################################################

if [ ! -e ${efsMount} ] ; then

	echo "Mount $efsMount Folder is not available"
	logger "${script_name}: Error - \"${efsMount}\" is not mounted yet, Manual intervention required"
	exit 0
else
	cd $efsMount
	echo "Changing the dir to $efsMount"
	x=$(ls | grep $BankUsername)
	echo $x

	if [[ $x != *"$BankUsername"* ]] ; then

		sudo mkdir -p $BankUsername/$dir1 $BankUsername/$dir2
		#sudo mkdir -p $BankUsername/$dir2
		sudo chmod -R 755 $BankUsername
		sudo chown $BankUsername:$BankUsername $efsMount/$BankUsername/$dir1 $efsMount/$BankUsername/$dir2
		#sudo chown $BankUsername:$BankUsername $efsMount/$BankUsername/$dir2

		echo "$BankUsername directory creation and permission done"
	fi

fi

#########################################################################

if [ ! -e ${VisaBank} ] ; then

	sudo mkdir -p $VisaBank/$dir1
	sudo mkdir -p $VisaBank/$dir2
	sudo chmod 755 $VisaBank
	sudo chown root:root $VisaBank

	echo "$VisaBank directory creation and permission done"
	
else
	echo "$VisaBank directory already exists"
fi

#########################################################################

sudo chown $VisaBankUsername:$VisaUsername $VisaBank/$dir1 $VisaBank/$dir2

sudo chmod 775 $VisaBank/$dir1 $VisaBank/$dir2

echo "$VisaBank/$dir1 and $VisaBank/$dir2 directory creation and permission done"

echo "Hence Moving to update the $config file"

if [ -f "$config" ] ; then

sudo bash -c "echo 'Match Group visa User $VisaBankUsername
ForceCommand internal-sftp
PasswordAuthentication yes
ChrootDirectory $VisaBank
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no

Match User $BankUsername
ForceCommand internal-sftp
PasswordAuthentication yes
ChrootDirectory $bank
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

echo "Restart completed and sftp visa pre-prod setup for $BankUsername bank is ready"

#########################################################################

