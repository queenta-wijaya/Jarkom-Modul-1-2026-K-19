#Install VSFTPD
apk update && apk add vsftpd inetutils-ftp
mkdir -p /var/wired/data

#Membuat akun
adduser -D alice
passwd alice

adduser -D mika
passwd mika

adduser -D eiri
passwd eiri

#Membuat kepemilikan direktori shared
chown -R alice:alice /var/wired/data
chmod 777 /var/wired/data

#Konfigurasi
cat << 'EOF' > /etc/vsftpd/vsftpd.conf
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
chroot_local_user=YES
allow_writeable_chroot=YES
local_root=/var/wired/data
userlist_enable=YES
userlist_file=/etc/vsftpd/userlist
userlist_deny=NO
user_config_dir=/etc/vsftpd/user_conf
EOF

#File etc/vsftpd/userlist untuk whitelist user alice dan mika
cat << 'EOF' > /etc/vsftpd/userlist
alice
mika
EOF

#Mengatur hak askes read-only untuk user mika via /etc/vsftpd/user_conf/mika
mkdir -p /etc/vsftpd/user_conf
cat << 'EOF' > /etc/vsftpd/user_conf/mika
write_enable=NO
EOF

#Jalankan service FTP
vstpd /etc/vstpd/vsftpd.conf &

#Tes hak akses
ftp 10.73.2.2