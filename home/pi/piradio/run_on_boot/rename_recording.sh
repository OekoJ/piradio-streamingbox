#!/bin/bash
darkice_config="../stream_config/stream_configuration.cfg"

## Make sure the script isn't already running 
################################################################################
if [ `ps -e | grep -c $(basename $0)` -gt 2 ]; then echo $(basename $0) is already running, stopping script; exit 0; fi
################################################################################

function addTimestampToFilename {
    # this function adds a timestamp to a filename which is passed together with its path
    # returns only filename (without path)
    filenameWithPath=$1;
    datestring=$(stat --printf='%y' $filenameWithPath) # get the modification date of file
    datestring=${datestring%.*} # cut it after "."
    datestring=${datestring// /_}  # replace all (//) Spaces by "_"
    datestring=${datestring//:/.}  # replace all (//) ":" by "."
    echo $datestring\_${filenameWithPath##*/}
}  

function recfilename {
	shopt -s extglob
	while IFS='= ' read lhs rhs
	do
	    if [[ ! $lhs =~ ^\ *# && -n $lhs ]]; then
		rhs="${rhs%%\#*}"    # Del in line right comments
		rhs="${rhs%%*( )}"   # Del trailing spaces
		rhs="${rhs%\"*}"     # Del opening string quotes 
		rhs="${rhs#\"*}"     # Del closing string quotes 
		# echo $lhs="$rhs"
		# declare $lhs="$rhs"
		if [ $lhs == localDumpFile ]; then 
			declare $lhs="$rhs"
		fi
	    fi
	done < $darkice_config
	echo $localDumpFile
}

file_to_rename=$(recfilename)
# if [ $file_to_rename ]; then echo Filename is: $file_to_rename; fi
if [ $file_to_rename ]; then
	# if [ -f $file_to_rename ] && [ $(stat -c%s "$file_to_rename") ];
	if [ -f $file_to_rename ] && [ -s $file_to_rename ]; # exists (-f) and is not zero size (-s)
		then
			destinationfile=$(addTimestampToFilename $file_to_rename)
			if mv $file_to_rename ${file_to_rename%/*}/$destinationfile
			then
			  echo Recording-Datei $destinationfile erfolgreich geschrieben
			else
			  echo "Fehler beim Umbenennen der Recording-Datei, exit status $?"
			fi
		else
			echo "Recording-Datei $file_to_rename existiert nicht!"
	fi
fi

