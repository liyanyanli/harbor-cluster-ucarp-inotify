#!/bin/bash

#example:./2main-harbor.sh /root/release_harbor 10.10.103.140 smtp.exmail.qq.com 25 598892742@qq.com aaaa 598892742@qq.com 123 10.10.101.77(nfs,ntp)

#./go.sh $1

./other.sh $1

./harbor/harbor-main.sh $1 $2 $3 $4 $5 $6 $7 $8

./clair/clair.sh $1








