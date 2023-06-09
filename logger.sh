#!/bin/bash

dir_log=`find /home -name 'WallpaperChanger'`"/log/"
file_log=login_attempts.log
short_dir=log/$file_log
if [[ ! -d log ]]; then
    echo "No log file was found. Creating.."
    mkdir $dir_log
    mkdir $dir_log/pics
    touch $dir_log$file_log
    echo "Created log file /log/$file_log"
fi

lines_num=`cat $short_dir | wc -l`

function make_bad_note_in_log {
    echo "№$(($lines_num+1)). Unauthorized login attempt  `date +"%F  %T"`" >> $short_dir
}

function make_good_note_in_log {
    echo "№$(($lines_num+1)). Successful authorized login attempt  `date +"%F  %T"`" >> $short_dir
}
