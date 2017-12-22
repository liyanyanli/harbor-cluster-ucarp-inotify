#!/bin/bash
#para

host=$1  #inotify-slave的ip地址
src=$2        #本地监控的目录

inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w%f' -e close_write,delete,create,attrib $src \
| while read file
do

rsync -ave ssh --delete $src root@$host:/ >/dev/null 2>&1

done
exit 0
