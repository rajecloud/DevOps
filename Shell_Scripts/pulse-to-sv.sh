#!/bin/bash
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin

script_name=${0##*/}
script_name=${script_name%.sh}
sv_target_dir="/nas/iofiles/sv-iofiles/incoming"
pulse_to_sv_filter="(D[0-9]{6}\.PL\..*\.FILEOUTA\.PRC[0-9]{3}\.sent)"
pulse_dir="/nas/sftp/pulse-sftp"
temp_file_name="copy_in_progress_file"
sent_file_suffix="sent_to_sv"

##############################################################################################################
if [ ! -e ${pulse_dir} ] ; then
    echo "The NAS directory \"${pulse_dir}\" is not mounted.  Exiting since we are not the active SFTP cluster member."
    exit
fi
logger "${script_name}: Starting send Pulse files to SV script \"$0\"."

##############################################################################################################
pulse_dir_path_length=$((${#pulse_dir} + 2))
fully_uploaded_list=`find $pulse_dir -maxdepth 1 -type f -regextype posix-egrep -regex "$pulse_dir/$pulse_to_sv_filter" | awk '{print substr(substr($1,1,length($1)-length(".sent")),'$pulse_dir_path_length')}'`
# echo List of files for SV consumption that are currently in the Pulse upload dir and which are fully uploaded:

##############################################################################################################
for file in ${fully_uploaded_list}
do
    if [ ! -f ${pulse_dir}/${file}.${sent_file_suffix} ] ; then

        if [ ! -f ${pulse_dir}/${file} ] ; then
            logger "${script_name}: Warning:  Found incoming Pulse file \"${pulse_dir}/${file}.sent\", but the matching source file \"${pulse_dir}/${file}\" does not currently exist.  Skipping this file but continuing pulse file processing."
            continue
        fi

        temporary_file=${sv_target_dir}/${temp_file_name}
        error_message=`cp -p ${pulse_dir}/${file} ${temporary_file} 2>&1`
        error_code=$?
        if [ ${error_code} -ne 0 ] ; then
            logger "${script_name}: Error ${error_code} copying pulse file \"${pulse_dir}/${file}\" to target file \"${temporary_file}\".  Manual intervention required.  Stopping pulse file processing.  Error message is:  ${error_message}"
            exit
        else
            error_message=`chmod 660 ${temporary_file} 2>&1`
            error_code=$?
            if [ ${error_code} -ne 0 ] ; then
                logger "${script_name}: Error ${error_code} setting access permissions on target file \"${temporary_file}\".  Manual intervention required.  Stopping pulse file processing.  Error message is:  ${error_message}"
                exit
            else
                error_message=`chown weblogic:weblogic ${temporary_file} 2>&1`
                error_code=$?
                if [ ${error_code} -ne 0 ] ; then
                    logger "${script_name}: Error ${error_code} setting owner and group on target file \"${temporary_file}\".  Manual intervention required.  Stopping pulse file processing.  Error message is:  ${error_message}"
                    exit
                else
                    error_message=`mv ${temporary_file} ${sv_target_dir}/${file} 2>&1`
                    error_code=$?
                    if [ ${error_code} -ne 0 ] ; then
                        logger "${script_name}: Error ${error_code} renaming temporary file \"${temporary_file}\" to \"${sv_target_dir}/${file}\".  Manual intervention required.  Stopping pulse file processing.  Error message is:  ${error_message}"
                        exit
                    else
                        error_message=`cp ${pulse_dir}/${file}.sent ${pulse_dir}/${file}.sent_to_sv 2>&1`
                        error_code=$?
                        if [ ${error_code} -ne 0 ] ; then
                            logger "${script_name}: Error ${error_code} creating \"${pulse_dir}/${file}.sent_to_sv\".  Manual intervention required.  Stopping pulse file processing.  Error message is:  ${error_message}"
                            exit
                        else
                            error_message=`chown weblogic:weblogic ${pulse_dir}/${file}.sent_to_sv 2>&1`
                            error_code=$?
                            if [ ${error_code} -ne 0 ] ; then
                                logger "${script_name}: Error ${error_code} changing ownership of \"${pulse_dir}/${file}.sent_to_sv\" to weblogic:weblogic.  Manual intervention required.  Stopping pulse file processing.  Error message is:  ${error_message}"
                                exit
                            else
                                logger "${script_name}: Successfully copied Pulse-uploaded file \"$pulse_dir/${file}\" to ${sv_target_dir}/${file} for SV processing."
                            fi
                        fi
                    fi
                fi
            fi
        fi  
    fi
done
