#!/bin/bash
# TODO
# Check if there is a file that contains a hashed password: +
#   If not, create it and set up a password. +
# If such a file exists: +
#   Read from keyboard a password: +
#       If passwords match: +
#           Change the desktop wallpapers to random cat pic:
#               Check if internet connection is available
#               Ping server
#           (To change wallpaper you need to know what theme scheme is!!)
#       If they do not match:
#           Lookup for web-camera:
#               If there is a web-cam take a picture of thief's face and make note in log.
#               (Needs sudo apt install fswebcam)
#               If no web-cam was found, make note in log
# ещё такая фишечка, что на картинке с котом будет логин компа +
#  

URL=https://cataas.com/cat?width=1920
URL2=https://cataa.com/cat/says/thief
PIC=picture.jpg
pswd_filename=password
tn=$'\t\n'

# Если пользователь ввёл 'q' как пароль, выходим из скрипта
function q_to_quit {
    if [[ $1 == q ]]; then
        exit 0;
    fi
}

# Хэшируем полученный пароль
function write_hash_md5 {
    pswd_hash=`echo $1 | md5sum | awk '{print $1}'`
    echo $pswd_hash >> $pswd_filename
}

# Регистрация: создаём файл, запрашивем пароль, хэшируем и кладём в файл
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

# Авторизация: сравниваем хэш из файла с хэшем полученного пароля
function authorization {
    read password < $pswd_filename

    while true
    do
        read -p "Enter password:$tn" -s inp_password
        inp_hash=`echo $inp_password | md5sum | awk '{print $1}'`
        if [[ $inp_hash == $password ]]; then
            echo "You were signed in successfully."
            return 1
        else
            echo "Incorrect password. You're a thief!"
            return 0
        fi
    done
}

function change_wallpaper {
    DIR=`find /home -name $PIC | grep WallpaperChanger/$PIC`
    scheme=`gsettings get org.gnome.desktop.interface color-scheme`
    if [[ "$scheme" == "'prefer-dark'" ]]; then
        gsettings set org.gnome.desktop.background picture-uri-dark file://$DIR
    else
        gsettings set org.gnome.desktop.background picture-uri file://$DIR
    fi
}

if [[ ! -f $pswd_filename ]]; then
    registration
    curl $URL -o $PIC
    change_wallpaper $PIC
    echo "Wallpaper has been changed."
else
    authorization
    if [[ $? -eq 1 ]]; then
        curl $URL -o $PIC
        change_wallpaper $PIC
        echo "Wallpaper has been changed."
    else
        echo "Searching for a webcam..."
        webcams=`find /dev/ -name video* | wc -l` 
#       На ноутбуках HP пишет, что их две(/dev/video0 и /dev/video1), но на самом деле вторая нужна для метаданных
        echo "Cameras found: $webcams."
        if [[ $webcams -gt 0 ]]; then
            echo "Taking a webcam shot..."
            fswebcam -r 1280x720 --jpeg 85 -D 1 $PIC
            sleep 1
            change_wallpaper $PIC
            echo "Wallpaper has been changed."
        else
            echo "No cameras was found."
            curl $URL2 -o $PIC
        fi
    fi
fi