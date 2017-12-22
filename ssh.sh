#!/usr/bin/env bash

# 1. IP
# 双机 ssh 免密登录

/usr/bin/ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ''

scp -p ~/.ssh/id_rsa.pub root@$1:/root/.ssh/authorized_keys
