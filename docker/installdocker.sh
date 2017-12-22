#!/bin/bash

# ./installdocker 10.10.10.10[harbor ip]

rpm -ivh *.rpm --nodeps --force

regitry='OPTIONS="--insecure-registry "'$1'""'

echo $regitry >> /etc/sysconfig/docker

systemctl start docker

systemctl restart docker

systemctl enable docker
