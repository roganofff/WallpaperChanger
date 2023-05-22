#!/bin/bash

if [[ -f "password" ]]; then
    rm password
fi

pass_file=correct_password

if [[ ! -f $pass_file ]]; then
    touch $pass_file
    echo "testcorrect" > $pass_file    
fi

password=`cat correct_password`

chmod +x ./change_wallpaper.sh
chmod +x ./logger.sh

echo $password | ./change_wallpaper.sh

