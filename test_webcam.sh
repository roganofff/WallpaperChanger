#!/bin/bash 

if [[ ! -f "password" ]]; then
    touch password
fi

pass_file=incorrect_password

if [[ ! -f $pass_file ]]; then
    touch $pass_file
    echo "testincorrect" > $pass_file  
fi

echo "`cat incorrect_password | md5sum | awk '{ print $1 }'`" > password 
password="otherpassword"

chmod +x change_wallpaper.sh
chmod +x logger.sh

echo $password | ./change_wallpaper.sh
