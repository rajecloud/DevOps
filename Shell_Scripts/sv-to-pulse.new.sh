#!/bin/bash
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin

script_name=${0##*/}
script_name=${script_name%.sh}
pulse_dir="/nas/sftp/pulse-sftp"

sv_outgoing_dir="/nas/iofiles/sv-iofiles/outgoing"
sv_to_perso_file_filter="(ftp982[0-9]{14})"
sv_archive_dir="/nas/archive/sv-outgoing"
perso_upload_dir="/yantrain"
perso_response_dir="/yantraout"
sent_file_suffix="sent_to_perso.gpg"
sending_file_suffix="sending_to_perso.gpg"
sftp_script_suffix="sftp_script"
response_file_suffix="response_from_perso"
completed_encrypted_file_suffix="tar.gpg"
log_suffix="log"

perso_ftp_server=""
yantra_perso_ftp_id="YANTRA"
yantra_perso_sftp_key=""
yantra_perso_sftp_key_public=""

recipient=""

##############################################################################################################
HOME=/root

##############################################################################################################
if [ ! -e ${pulse_dir} ] ; then
    echo "The NAS directory \"${pulse_dir}\" is not mounted.  Exiting since we are not the active SFTP cluster member."
    exit
fi
logger "${script_name}:  Starting send SmartVista files to Perso script \"$0\"."

##############################################################################################################
sv_outgoing_list=`find ${sv_outgoing_dir} -maxdepth 1 -type f -regextype posix-egrep -regex "${sv_outgoing_dir}/${sv_to_perso_file_filter}"`

sv_outgoing_dir_path_length=$((${#sv_outgoing_dir} + 1))
for file in ${sv_outgoing_list}
do
    file_name=${file:${sv_outgoing_dir_path_length}}
    if [ ! -f ${sv_archive_dir}/${file_name}.${completed_encrypted_file_suffix} ] && [ ! -f ${sv_archive_dir}/${file_name}.${sent_file_suffix} ] ; then
        if [ ! -f ${sv_archive_dir}/${file_name} ] ; then
            error_message=`cp -p ${file} ${sv_archive_dir}/${file_name} 2>&1`
            error_code=$?
            if [ ${error_code} -ne 0 ] ; then
                logger "${script_name}:  Error ${error_code} copying SmartVista Perso card personalization file \"${file}\" to the archive directory as \"${sv_archive_dir}/${file_name}\".  Manual intervention required.  Stopping file processing.  Error message is:  ${error_message}"
                exit
            else
                logger "${script_name}:  Successfully copied newly created SmartVista card personalization file \"${file}\" to \"${sv_archive_dir}/${file_name}\" in preparation for submission to Perso for processing."
            fi
        fi
    fi
done

##############################################################################################################
candidate_list=`find ${sv_archive_dir} -maxdepth 1 -type f -regextype posix-egrep -regex "${sv_archive_dir}/${sv_to_perso_file_filter}"`

##############################################################################################################
sv_archive_dir_path_length=$((${#sv_archive_dir} + 1))

for file in ${candidate_list}
do
    file_name=${file:${sv_archive_dir_path_length}}

    if [ ! -f ${sv_archive_dir}/${file_name}.${completed_encrypted_file_suffix} ] && [ ! -f ${file}.${sent_file_suffix} ] ; then
        ######################################################################################################
        log_file=${file}.${log_suffix}
        echo >> ${log_file}
        echo >> ${log_file}
        echo `date`:  ${script_name} >> ${log_file}
        echo "Processing card personalization file \"${file}\"." >> ${log_file}
        sending_file=${file}.${sending_file_suffix}
        if [ -f ${sending_file} ] ; then
            logger -s "${script_name}:  Warning:  The previous Perso upload process for file \"${file_name}\" may be hung up based on the continued existence of the file \"${sending_file}\".  Manual follow-up may be required.  Skipping file for now." 2>> ${log_file}
            continue
        fi

        ######################################################################################################
        echo "Encrypting the source file to the sending file \"${sending_file}\"..." >> ${log_file}
        #error_message=`cp -p ${file} ${sending_file} 2>&1`
	error_message=`gpg -v --output ${sending_file} --encrypt --homedir /root/.gnupg --recipient ${recipient} ${file} 2>&1`
        error_code=$?
        echo ${error_message} >> ${log_file}
        if [ ${error_code} -ne 0 ] ; then
            logger -s "${script_name}:  Error ${error_code} encrypting file \"${file}\" to sending file.  Manual intervention required.  Stopping file processing.  The error message was:  ${error_message}" 2>> ${log_file}
            exit
        fi

        ######################################################################################################
        echo "Checking to see if a response for this card file already exists in the Perso response directory \"${perso_response_dir}\"..." >> ${log_file}

        error_message=`/usr/bin/curl -u ${yantra_perso_ftp_id}: --key ${yantra_perso_sftp_key} --pubkey ${yantra_perso_sftp_key_public} -o ${file}.${response_file_suffix} sftp://${perso_ftp_server}${perso_response_dir}/${file_name} 2>&1`
        error_code=$?
        echo ${error_message} >> ${log_file}
         
        if [ ${error_code} -ne 0 ] ; then
            echo "No Perso response file is yet available for this card file." >> ${log_file}
            error_message=`rm -f ${file}.${response_file_suffix} 2>&1`
        else
            echo "Found an already available response file \"${perso_response_dir}/${file_name}\" in the Perso response directory and downloaded it to \"${file}.${response_file_suffix}\"." >> ${log_file}
            logger -s "${script_name}:  The upload of card personalization file \"${file_name}\" to the Perso SFTP site has been cancelled since a Perso response file for the file already exists in the Perso download directory.  Created \"${file}.${response_file_suffix}\"." 2>> ${log_file}

            error_message=`mv ${sending_file} ${file}.${sent_file_suffix} 2>&1`
            error_code=$?
            echo ${error_message} >> ${log_file}
            if [ ${error_code} -ne 0 ] ; then
                logger -s "${script_name}:  Error ${error_code} renaming file \"${sending_file}\" to \"${file}.${sent_file_suffix}\".  Manual intervention required.  Stopping file processing.  Error message is:  ${error_message}" 2>> ${log_file}
                error_message=`rm -f ${sending_file} 2>&1`
                exit
            fi
            continue
        fi

        ######################################################################################################
        echo "Starting SFTP upload of card personalization file \"${file_name}\" to Perso..." >> ${log_file}

        error_message=`/usr/bin/curl -u ${yantra_perso_ftp_id}: --key ${yantra_perso_sftp_key} --pubkey ${yantra_perso_sftp_key_public} -T ${sending_file} sftp://${perso_ftp_server}${perso_upload_dir}/${file_name} 2>&1`
        error_code=$?
        echo ${error_message} >> ${log_file}

        if [ ${error_code} -ne 0 ] ; then
            logger -s "${script_name}:  Error ${error_code} uploading file \"${file}\" to Perso.  Skipping file for now.  The error message was:  ${error_message}" 2>> ${log_file}
            error_message=`rm -f ${sending_file} 2>&1`
            continue
        fi

        logger -s "${script_name}:  The upload of card personalization file \"${file_name}\" to Perso completed successfully." 2>> ${log_file}
        echo "Changing the suffix of the file to "${sent_file_suffix}" to indicate a successful upload..." >> ${log_file}

        error_message=`mv ${sending_file} ${file}.${sent_file_suffix} 2>&1`
        error_code=$?
        echo ${error_message} >> ${log_file}
        if [ ${error_code} -ne 0 ] ; then
            logger -s "${script_name}:  Error ${error_code} renaming file \"${sending_file}\" to \"${file}.${sent_file_suffix}\".  Manual intervention required.  Stopping file processing." 2>> ${log_file}
            exit
        fi

        error_message=`touch ${file}.${sent_file_suffix} 2>&1`
    fi
done
