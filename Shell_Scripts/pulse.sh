#!/bin/bash
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin

script_name=${0##*/}
script_name=${script_name%.sh}
pulse_to_sv_filter="(D[0-9]{6}\.PL\..*\.FILEOUTA\.PRC[0-9]{3}\.SENT)"
additional_drop_filter=".PL.HXS.D10A.PRC651"
sv_to_cbw_filter="(ftp.*|OBI.*|statement.*)"
pulse_dir="/nas/sftp/pulse-sftp"
cbw_dir="/nas/sftp/cbw-sftp/sv"
recipient=""
report_recipient=""
temp_file_name="temporary_encryption_work_file_2"
sync_days=10
copy_email=""
zip_source_name="pulse-to-cbw.reports.zip"
currentdatetime=$(date +'%Y-%m-%d_%H:%M')
currentdate=$(date +'%Y-%m-%d')
gpg_zip_source_name="pulse-to-cbw.reports.${currentdatetime}.zip.gpg"
list_of_reports=()
additional_drop_dir="/nas/sftp/pulse-dropbox"

##############################################################################################################
if [ ! -e ${pulse_dir} ] ; then
    echo "The NAS directory \"${pulse_dir}\" is not mounted.  Exiting since we are not the active SFTP cluster member."
    exit
fi
logger "${script_name}:  Starting Pulse to CBW encryption script \"$0\"."

##############################################################################################################
sv_outgoing_path_length=$((${#pulse_dir} + 2))
source_list=`find ${pulse_dir} -maxdepth 1 -type f -mtime -${sync_days} -regextype posix-egrep ! -regex "${pulse_dir}/${pulse_to_sv_filter}" -exec ls -lt --time-style=+%Y%m%d%H%M%S {} \; | \
    grep ".SENT$" | awk '{print $6"."substr($7,'$sv_outgoing_path_length',length($7)-4-'$sv_outgoing_path_length')".pgp"}'`

#echo List of would-be download filenames for Pulse files currently in the Pulse SFTP directory:
echo $source_list

##############################################################################################################
new_file_list=""
for file in ${source_list}
do
    if [ ! -f ${cbw_dir}/${file} ] ; then
        new_file_list="${new_file_list} ${file}"
    fi
done

#echo New file list:
#echo ${new_file_list}

##############################################################################################################
temp_name="${cbw_dir}/${temp_file_name}"
for target_file in ${new_file_list}
do
    error_message=`rm -f ${temp_name} 2>&1`
    source_name=${target_file%.pgp}
    source_name=${source_name:15}
    temp_source_name="/tmp/${source_name}.report"
    additional_drop_name="${additional_drop_dir}/${source_name}.report"
    source_name="${pulse_dir}/${source_name}"
    target_name="${cbw_dir}/${target_file}"
    if [ ! -f ${source_name} ] ; then
        logger "${script_name}: Expected source Pulse file \"${source_name}\" not found.  Perhaps manually deleted.  File skipped."
    else
        error_message=`gpg -v --output ${temp_name} --encrypt --homedir /root/.gnupg --recipient ${recipient} ${source_name} 2>&1`
        error_code=$?
        if [ ${error_code} -ne 0 ] ; then
            logger "${script_name}: Error ${error_code} encrypting source Pulse file \"${source_name}\" for download.  Manual intervention required.  File skipped.  Error message is:  ${error_message}"
        else
            error_message=`mv ${temp_name} ${target_name} 2>&1`
            error_code=$?
            if [ ${error_code} -ne 0 ] ; then
                logger "${script_name}: Error ${error_code} renaming already encrypted Pulse file \"${source_name}\" to the target name \"${target_name}\".  Manual intervention required.  File skipped.  Error message is:  ${error_message}"
            else
                logger "${script_name}: Successfully encrypted Pulse file \"${source_name}\" for download under the name \"${target_name}\"."
		#copy file to tmp for emailing and put additional drop out there as well
		list_of_reports=(${list_of_reports[@]} "${temp_source_name:5}")
		error_message=$(cp ${source_name} ${temp_source_name} 2>&1)
		error_code=$?
            	if [ ${error_code} -ne 0 ] ; then
			logger "${script_name}: Error ${error_code} copying file \"${source_name}\" to \"${temp_source_name}\". Error message is : ${error_message}"
		fi
		logger "${script_name}: Additional file drop running for $additional_drop_name."
		case "$additional_drop_name" in
		*"$additional_drop_filter"* )
			logger "${script_name}: Additional filter matched for ${additional_drop_name:24}."
			list_of_additional_reports=(${list_of_additional_reports[@]} "${additional_drop_name:24}")
			logger "${script_name}: Copying ${source_name} to ${additional_drop_name} for additional file drop."
			error_message=$(cp ${source_name} ${additional_drop_name} 2>&1)
			error_code=$?
            		if [ ${error_code} -ne 0 ] ; then
				logger "${script_name}: Error ${error_code} copying file \"${source_name}\" to \"${additional_drop_name}\". Error message is : ${error_message}"
			fi
		;;
		esac
            fi
        fi
    fi
done
#Zip up temp attachments
error_message=$(zip /tmp/${zip_source_name} /tmp/*.report 2>&1)
error_code=$?
if [ ${error_code} -ne 0 ] ; then
	logger "${script_name}: Error ${error_code} creating zip file /tmp/${zip_source_name} from /tmp/*.report file. Error message is : ${error_message}"
else
	#Encrypt zip file
	error_message=`gpg -v --output /tmp/${gpg_zip_source_name} --encrypt --homedir /root/.gnupg --recipient ${report_recipient} /tmp/${zip_source_name} 2>&1`
	error_code=$?
	if [ ${error_code} -ne 0 ] ; then
		logger "${script_name}: Error ${error_code} encrypting /tmp/\"${gpg_zip_source_name}\" from file \"${zip_source_name}\". Error message is : ${error_message}"
	else
		# Mail file copy to Randy
		message=${gpg_zip_source_name}' is attached.\n'
		for reportfilename in "${list_of_reports[@]}"
		do
			message=${message}'\n'${reportfilename}
		done
		
		
		error_message=$(echo -e "${message}" | mailx -s "Copy of pulse-to-cbw reports. ${gpg_zip_source_name}" -r "YLISFTP ROOT <root@ylisftp.yantracard.com>" -a /tmp/${gpg_zip_source_name} ${copy_email} 2>&1)
		error_code=$?
		if [ ${error_code} -ne 0 ] ; then
		logger "${script_name}: Error ${error_code} sending copy of file /tmp/\"${gpg_zip_source_name}\" via email. Error message is : ${error_message}"
		fi
	fi
fi
#Cleanup temp files
for i in $(ls /tmp/*.report); do
	error_message=$(unlink ${i} 2>&1)
	error_code=$?
	if [ ${error_code} -ne 0 ] ; then
		logger "${script_name}: Error ${error_code} removing temporary file ${i}.  Error message is : ${error_message}"
	fi	
done
error_message=$(unlink /tmp/${zip_source_name} 2>&1)
error_code=$?
if [ ${error_code} -ne 0 ] ; then
	logger "${script_name}: Error ${error_code} removing temporary file /tmp/${zip_source_name}.  Error message is : ${error_message}"
fi	
error_message=$(unlink /tmp/${gpg_zip_source_name} 2>&1)
error_code=$?
if [ ${error_code} -ne 0 ] ; then
	logger "${script_name}: Error ${error_code} removing temporary file /tmp/${gpg_zip_source_name}.  Error message is : ${error_message}"
fi	

#Zip up and copy additional attachments
new_additional_dir="${additional_drop_dir}/${currentdate}"
for additionalfilename in $(ls ${additional_drop_dir}/*.report)
do
	additionalfilename=$(basename $additionalfilename)
	error_message=$(mkdir -p ${new_additional_dir} 2>&1)
	error_code=$?
	if [ ${error_code} -ne 0 ] ; then
		logger "${script_name}: Error ${error_code} creating directory ${new_additional_dir}. Error message is : ${error_message}"
	fi
	error_message=$(chown pulse.pulse-sftp ${new_additional_dir} 2>&1)
	error_code=$?
	if [ ${error_code} -ne 0 ] ; then
		logger "${script_name}: Error ${error_code} chowning dir ${new_additional_dir}. Error message is : ${error_message}"
	fi
	logger "${script_name}: Zipping additional file ${additional_drop_dir}/${additionalfilename} to ${new_additional_dir}/${additionalfilename%.report}.zip."
	error_message=$(zip -j ${new_additional_dir}/${additionalfilename%.report}.zip ${additional_drop_dir}/${additionalfilename} 2>&1)
	error_code=$?
	if [ ${error_code} -ne 0 ] ; then
		logger "${script_name}: Error ${error_code} creating zip file ${new_additional_dir}/${additionalfilename%.report}.zip from ${additional_drop_dir}/${additionalfilename} file. Error message is : ${error_message}"
	fi
	chown pulse.pulse-sftp ${new_additional_dir}/${additionalfilename%.report}.zip
done
#Cleanup temp files
for i in $(ls ${additional_drop_dir}/*.report); do
	error_message=$(unlink ${i} 2>&1)
	error_code=$?
	if [ ${error_code} -ne 0 ] ; then
		logger "${script_name}: Error ${error_code} removing temporary file ${i}.  Error message is : ${error_message}"
	fi	
done
