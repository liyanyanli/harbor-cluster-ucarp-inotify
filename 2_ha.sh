#!/usr/bin/env bash

#./ucarp.sh /root/ha/docker-harbor-cluster/release_harbor 40 love 10.10.103.222 10.10.103.141 eth0 10.10.103.143

./inotify_rsync/install.sh $1

./ucarp/ucarp.sh $1 $2 $3 $4 $5 $6 $7
