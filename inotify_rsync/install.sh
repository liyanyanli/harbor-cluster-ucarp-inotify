#!/usr/bin/env bash

cd $1/build/inotify_rsync

rpm -Uvh inotify-tools-3.14-8.el7.x86_64.rpm

if [ ! -d "/etc/uuarp" ]
then
        mkdir /etc/uuarp
fi

cp inotify.sh /etc/uuarp/inotify.sh
