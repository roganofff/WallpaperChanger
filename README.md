# WallpaperChanger

## Функции скрипта
- Регистрация и авторизация
- Обращение к API для скачивания картинок
- Скриншот с веб-камеры
- Установка картинок на рабочий стол
- Создание лог файла для всех попыток вхождения

## Зависимости
- Video4Linux
- fswebcam

## Установка
```bash
sudo apt install v4l-utils
```
```bash
sudo apt install fswebcam
```

## Использование
Запустите скрипт ```change_wallpaper.sh```. 

При первом запуске будет доступна регистрация. После этого обои на рабочем столе будут заменены картинкой кота, а в папке ```log``` в файл ```login_attempts.log``` будет регистрироваться время и дата входа.

После повторного запуска скрипт запросит ввести пароль. При вводе верного пароля обои вновь будут заменены картинкой кота, а в логах появится запись.

Если пароль неверный, то скрипт делает скриншот с веб-камеры, устанавливает его как обои и в папке с логами переносит картинку с датой в ```log/pics/``` и делает запись в лог.  
Если веб-камера отсутствует, скрипт заменяет фото с неё картинкой кота с надписью **thief**. 