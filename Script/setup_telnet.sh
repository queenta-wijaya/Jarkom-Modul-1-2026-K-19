#!/bin/sh

apk update
apk add busybox-extras

adduser -D phantom_user
echo "phantom_user:wired_ghost" | chpasswd

telnetd -F -p 23 &