#!/bin/bash
# TODO
# Check if there is a file that contains a hashed password:
#   If not, create it and set up a password.
# If such a file exists:
#   Read from keyboard a password:
#       If passwords match:
#           Change the desktop wallpapers to random cat pic
#       If they do not match:
#           Lookup for web-camera:
#               If there is a web-cam take a picture of thief's face and set up it as a wallpaper.
#               If no web-cam was found, do nothing
# ещё такая фишечка, что на картинке с котом будет логин компа

pswd_filename=password
tn=$'\t\n'

function q_to_quit {
    if [[ $1 == q ]]; then
        exit 0;
    fi
}

function write_hash_md5 {
    pswd_hash=`echo $1 | md5sum | awk '{print $1}'`
    echo $pswd_hash >> $pswd_filename
}

function registration {
    echo "No saved password was found."
    echo "Creating a file to save a new password..."
    touch $pswd_filename

    while true
    do
        read -p "Enter a new password:$tn" -s password1
        q_to_quit $password1
        read -p "Repeat it again:$tn" -s password2
        q_to_quit $password2
        if [[ $password1 == $password2 ]]
        then
            if [[ "$password1" == " " || "$password1" == "" ]]; then
                echo "Your password cannot contain a space or be empty."
                continue
            fi
            echo "You were signed in successfully."
            write_hash_md5 $password1
            break
        else
            echo "Error. Passwords do not match."
        fi
    done
}

function authorization {
    read password < $pswd_filename

    while true
        read -p "Enter password: " -s inp_password
        inp_hash=`echo $inp_password | md5sum | awk '{print $1}'`
        if [[ $inp_hash == $password ]]; then
            echo "You were signed in successfully."
        else
            echo "Try again."
}

if [[ ! -f $pswd_filename ]]; then
    registration
else
    authorization
fi