#Chisa
apk update
apk add busybos-extras
adduser -D phantom_user
echo "phantom_user:wired_ghost" | chpasswd
telnetd -F -p 23 &

#Eiri
telnet 10.73.2.2 23
whoami
