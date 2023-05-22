#!/bin/bash 

if [[ ! -f "password" ]]; then
    touch password
fi

pass_file=correct_password

if [[ ! -f $pass_file ]]; then
    touch $pass_file
    echo "testcorrect" > $pass_file  
fi

echo "`cat correct_password | md5sum | awk '{ print $1 }'`" > password 
password=`cat correct_password`

chmod +x change_wallpaper.sh
chmod +x logger.sh

echo $password | ./change_wallpaper.sh
