#!/bin/bash
. ./logger.sh

URL=https://cataas.com/cat?width=1920
URL2=https://cataas.com/cat/says/thief
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

function download_cat {
    echo "Downloading a picture of a cat:3"
    curl $1 -o $PIC
    change_wallpaper $PIC   
    echo "Wallpaper has been changed."
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

# Меняет обои на полученную картинку
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
    download_cat $URL
    echo "Making notes in log file."
    make_good_note_in_log   
else
    authorization
    if [[ $? -eq 1 ]]; then
        download_cat $URL
        echo "Making notes in log file."
        make_good_note_in_log
    else
        echo "Searching for a webcam..."
        webcams=`find /dev/ -name video* | wc -l` 
#       На ноутбуках HP пишет, что их две(/dev/video0 и /dev/video1), но на самом деле вторая нужна для метаданных
        echo "Cameras found: $webcams."
        if [[ $webcams -gt 0 ]]; then
            echo "Taking a webcam shot..."
            fswebcam -r 1280x720 --jpeg 100 -D 1 $PIC
            sleep 1
            cp $PIC log/pics
            date_time=`date +"%F_%T"`
            mv log/pics/$PIC log/pics/picture_"$date_time".jpg
            echo "Making notes in log file."
            make_bad_note_in_log
            change_wallpaper
            echo "Wallpaper has been changed."
        else
            echo "No cameras was found."
            download_cat $URL2
            echo "Making notes in log file."
            make_good_note_in_log
        fi
    fi
fi