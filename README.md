# Jarkom-Modul-1-2026-K-19
## Anggota Kelompok
| Nama | NRP |
| --- | --- |
| Ni Putu Maqueenta Wijaya | 5027251004 |
| Malikha Syafira Dewi | 5027251032 |
## Pembahasan Soal Jarkom Modul 1
 **1. Untuk mempersiapkan pembangunan The Wired, Lain yang berperan sebagai Router membuat tiga Switch/Gateway: Switch 1 menuju dua Entitas yaitu Alice dan Mika, Switch 2 menuju Chisa, sedangkan Switch 3 menuju Knights dan Eiri. Kelima Entitas tersebut dikonfigurasi sebagai Client di GNS3.**
### Penyelesaian:
![img](assets/Soal1.png)<br>
Menambahkan Router (Alpinet) dengan nama `Lain`, 3 buah switch yang dihubungkan ke router Lain, dan 5 Node (Alpinet) yakni `Alice` dan `Mika` yang terhubung ke switch 1, `Chisa` yang terhubung ke switch 2, dan `Knights` dan `Eiri` yang terhubung ke switch 3.
<br>
Masing-masing node dikonfigurasikan sebagai berikut:
1. Lain
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 10.73.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.73.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 10.73.3.1
    netmask 255.255.255.0

up sysctl -w net.ipv4.ip_forward=1
```

2. Alice
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.1.2
    netmask 255.255.255.0
    gateway 10.73.1.1
```

3. Mika
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.1.3
    netmask 255.255.255.0
    gateway 10.73.1.1
```

4. Chisa
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.2.2
    netmask 255.255.255.0
    gateway 10.73.2.1
```

5. Knights
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.3.2
    netmask 255.255.255.0
    gateway 10.73.3.1
```

6. Eiri
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.73.3.3
    netmask 255.255.255.0
    gateway 10.73.3.1
```

**2. Karena menurut Lain pada saat itu The Wired masih terisolasi dari dunia luar, konfigurasikan router Lain agar dapat tersambung langsung ke jaringan internet publik melalui NAT/DHCP pada interface eth0.**
### Penyelesaian:
![img](assets/Soal2.png)<br>
Menambahkan NAT yang tersambung ke router Lain. Konfigurasi Lain diubah menjadi sebagai berikut:
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 10.73.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.73.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 10.73.3.1
    netmask 255.255.255.0

up sysctl -w net.ipv4.ip_forward=1
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```
Dan pada masing-masing node seperti Alice, Mika, Chisa, Knights, dan Eiri ditambahkan konfigurasi sebagai berikut agar tidak perlu konfigurasi ulang setiap node dimatikan.
```
up echo "nameserver 1.1.1.1" > /etc/resolv.conf
up echo "nameserver 8.8.8.8" >> /etc/resolv.conf
```
**3. Setelah router Lain terhubung ke internet, pastikan seluruh Entitas (Client) di bawah Switch 1, Switch 2, dan Switch 3 dapat saling terhubung dan berkomunikasi satu sama lain melalui konfigurasi routing.**
### Penyelesaian:
Soal ini dapat dibuktikan dengan mencoba `ping` ke masing-masing node client. Contoh dari berhasil melakukan ping adalah sebagai berikut:<br>
Router Lain mencoba ping ke Node Clien Eiri<br>
![img](assets/Soal3-1.png)<br>
Node Client Alice mencoba ping ke Node Clien Chisa<br>
![img](assets/Soal3-2.png)<br>

**4. Lain ingin agar setiap Entitas (Client) memiliki kemandirian di The Wired. Konfigurasikan firewall/iptables (NAT Masquerade) dan DNS resolver agar setiap Client dapat terhubung ke internet secara mandiri (dapat melakukan ping ke 8.8.8.8 dan membuka domain web google.com).**
### Penyelesaian:
Nomor ini bisa diselesaikan dengan mencoba `ping` ke `google.com` dari masing-masing Node Client. Contoh dari berhasil melakukan ping ke `google.com` adalah sebagai berikut:<br>
Node Client Eiri melakukan ping ke `google.com`<br>
![img](assets/Soal_4.png)

**5. Eiri tetap berupaya menanamkan kekacauan ke dalam jaringan. Untuk mengantisipasi restart tiba-tiba, pastikan seluruh konfigurasi jaringan tidak hilang saat semua node di-restart. Buat script verifikasi di /root/cek_status.sh pada router Lain yang menampilkan ringkasan interface (ip -br a) dan status tabel NAT (iptables -t nat -L -v -n) setelah reboot.**
### Penyelesaian:
Soal ini diselesaikan dengan membuka konsol Router Lain dan membuat file script `cek_status.sh` pada root sebagai berikut:<br>
```
nano /root/cek_status.sh
```
kemudian
```
#!/bin/sh
echo "=========================================="
echo "          RINGKASAN INTERFACE             "
echo "=========================================="
ip -br a

echo ""
echo "=========================================="
echo "            STATUS TABEL NAT              "
echo "=========================================="
iptables -t nat -L -v -n
```
Kemudian dijalankan dengan
```
chmod +x /root/cek_status.sh
/root/cek_status.sh
```
Hasil dari `cek_status.sh` adalah sebagai berikut:
![img](assets/Soal_5.png)<br>
**6. Mika mencurigai adanya anomali traffic pada segmen jaringannya. Jalankan generator traffic pada node Mika, lalu lakukan packet sniffing menggunakan Wireshark pada interface node Mika. Terapkan display filter khusus untuk menyaring paket yang berprotokol DNS atau ICMP. Tunjukkan screenshot hasil filter beserta ringkasan paket yang lolos.
### Penyeleseian :
Membuka console nose Mika, lalu buat script:
```
nano traffic_protocol7.sh
```
kemudian
```
# ============================================
# Traffic Generator — Protocol 7 Network
# Serial Experiments Lain — Modul 1 Jarkom 2026
# Jalankan di node MIKA untuk generate traffic DNS & ICMP
# ============================================

echo "============================================"
echo "  Protocol 7 Traffic Generator v2026"
echo "  Node: Mika Iwakura"
echo "============================================"
echo "[*] Generating DNS & ICMP traffic..."

# ICMP Traffic
ping -c 5 8.8.8.8 &
ping -c 5 1.1.1.1 &
ping -c 3 its.ac.id &

# DNS Queries
nslookup google.com 8.8.8.8 &
nslookup its.ac.id 8.8.8.8 &
nslookup github.com 1.1.1.1 &
dig @8.8.8.8 example.com A &
dig @1.1.1.1 cloudflare.com AAAA &

wait
echo "[*] Traffic generation complete."
echo "[*] Check Wireshark for captured packets."
```
menjalankan script dibawah ini sambil melakukan Start Capture di wireshark pada jalur mika 
```
chmod +x traffic_protocol7.sh
./traffic_protocol7.sh
```
Hasil Wireshark
Filter `dns or icmm`
![img](assets/soal_6.png)
Analisis Protocol Hierarchy
![img](assets/soal(2)_6.png)
Trafik yang tersaring didominasi oleh DNS (90%) hasil dari perintah nslookup dan dig ke berbagai domain (google.com, github.com, its.ac.id, cloudflare.com), dan ICMP (10%) hasil dari perintah ping ke 8.8.8.8 dan 1.1.1.1. Filter gabungan "dns or icmp" berhasil menyaring 40 dari total 22.895 paket yang ter-capture.
**7. Chisa memutuskan mendirikan FTP Server pada node miliknya dengan shared folder di /var/wired/data. Terapkan kebijakan akses: user alice (hak akses read & write), user mika (dibatasi read-only), dan user eiri (dibatasi tanpa izin akses / blacklist). Buktikan konfigurasi dengan membuat file signal_alice.txt dari user alice, dan buktikan penolakan akses saat user eiri mencoba login.
### Penyelesaian: 
Membuka console di node chisa, setelah itu install `vsftpd` dan membuat direktori shared;
```
apk update && apk add vsftpd inetutils-ftp
mkdir -p /var/wired/data
```
selanjutnya membuat akun `alice`, `mika` dan `eiri`:
```
adduser -D alice
passwd alice

adduser -D mika
passwd mika

adduser -D eiri
passwd eiri
```
membuat kepemilikan direktori shared 
``` 
chown -R alice:alice /var/wired/data
chmod 777 /var/wired/data
```
Membuat file konfigurasi `/etc/vsftpd/vsftpd.conf` menggunakan `cat << 'EOF'`
````
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
```

Membuat file `etc/vsftpd/userlist` untuk whitelist user `alice` dan `mika` 
```
cat << 'EOF' > /etc/vsftpd/userlist
alice
mika
EOF
```
Mengatur hak askes read-only untuk user `mika` via `/etc/vsftpd/user_conf/mika`
```
mkdir -p /etc/vsftpd/user_conf
cat << 'EOF' > /etc/vsftpd/user_conf/mika
write_enable=NO
EOF
```

Menjalankan service FTP 

``` 
vstpd /etc/vstpd/vsftpd.conf &
```

Menguji Hak akses menggunakan 
``` 
ftp 10.73.2.2
```
Login alice 
![img](assets/soal(1)_7.png)
Login mika 
![img](assets/soal(2)_7.png)
Login eiri
![img](assets/soal(3)_7.png)
**8. Kelompok rahasia Knights perlu mengirimkan dokumen laporan intelijen ke FTP Server Chisa. Lakukan koneksi FTP client dari node Knights ke FTP Server Chisa menggunakan akun alice. Upload file yang telah disediakan. Analisis sesi Wireshark dan sebutkan: perintah FTP untuk upload (STOR), kode status sukses server (226), dan port data TCP yang dinegosiasikan pada mode PASV.
### Penyelesaian:
Di node Knights, membat file dokumen laporan intelijen:
```
nano knights_report.txt
```
masukkan isi dari knights_report.txt
```
==================================================
  KNIGHTS OF THE EASTERN CALCULUS — STATUS REPORT
  Protocol 7 Surveillance Network
  Classification: LEVEL 7 — EYES ONLY
==================================================

Date: [CLASSIFIED]
Agent: Knights Unit Alpha
Node: Switch 3 — Subnet 10.<PREFIX>.3.0/24
---

SUBJECT: Network Reconnaissance Report

The Wired has been successfully infiltrated through
Protocol 7 channels. Current observations:

1. Router "Lain" has been identified as the central
   gateway node connecting all three subnet segments.

2. Switch 1 (10.<PREFIX>.1.0/24) hosts Alice and Mika.
   Both nodes show standard traffic patterns.

3. Switch 2 (10.<PREFIX>.2.0/24) hosts Chisa alone.
   Isolated subnet — minimal cross-traffic observed.

4. Switch 3 (10.<PREFIX>.3.0/24) — our operational base.
   Knights and Eiri coexist on this segment.

RECOMMENDATION:
Continue monitoring FTP and Telnet sessions for
plaintext credential exposure. SSH tunnels remain
impenetrable without keylog access.

--- END OF REPORT ---
Knights of the Eastern Calculus
"Let's all love Lain."
```
Jalankan capture wireshark pada link `Knights`
Hubungkan ke FTP server Chisa dan ulpad file 
```
ftp 10.73.2.2
# Login: alice / Pass: password
passive
put knights_report.txt
bye
```
Menghentikan capture dan menerapkan filer ftp pada Wireshark untuk dianlasis 
Perintah FTP untuk upload (STOR):
![img](assets/soal(1)_8.png)
kode status sukses server (226):
![img](assets/soal(3)_8.png)
port data TCP yang dinegosiasikan pada mode PASV:
![img](assets/soal(2)_8.png)
Respon Server PASV: `227 Entering Passive Mode (10,73,2,2,119,238)`[cite: 1]
Analisis & Perhitungan Port Data: Dua angka terakhir pada respon PASV merupakan pasangan oktet *High Byte* ($p1$) dan *Low Byte* ($p2$)[cite: 1]. Angka **256** digunakan sebagai faktor pengali karena merupakan batas kapasitas 1 byte ($2^8 = 256$) untuk menggeser posisi *High Byte* ke dalam format port 16-bit sesuai standar RFC 959.
 $$\text{Port Data TCP} = (119 \times 256) + 238 = 30464 + 238 = 30702$$
Sehingga, transfer data FTP dilakukan melalui port TCP **30702**.
**9. Mika mengakses dokumen Protokol Tujuh yang telah disediakan dari FTP Server Chisa. Dari node Mika, unduh file tersebut menggunakan akun mika. Setelah itu, buktikan pembatasan read-only dengan mencoba mengunggah file baru dari akun mika, dan tunjukkan pesan error respon server (error 550 Permission denied) saat mika mencoba melakukan upload.
### Penyelesaian: 
Di Node `Chisa` menyiapkan file `protocol7_manifesto.txt`
```
nano protocol7_manifesto.txt
```
Isi dari file `protocol7_manifesto.txt`
```
==================================================
  PROTOCOL 7 — THE MANIFESTO
  A Declaration of Digital Consciousness
  Serial Experiments Lain — Year 2026
==================================================

ARTICLE I: THE NATURE OF THE WIRED
-----------------------------------
The Wired is not merely a network of interconnected
machines. It is the collective unconscious of
humanity, rendered in packets and protocols.

Every TCP handshake is a conversation.
Every DNS query is a question.
Every encrypted tunnel is a whispered secret.

ARTICLE II: THE SEVEN PRINCIPLES
----------------------------------
1. All nodes are equal in the eyes of the router.
2. No packet shall be dropped without cause.
3. Encryption is the right of every connection.
4. Plaintext protocols expose the vulnerable.
5. The firewall protects, but also imprisons.
6. NAT masquerade hides truth behind a single face.
7. The Wired remembers everything — packet loss
   is merely a temporary forgetting.

ARTICLE III: THE PROPHECY OF LAIN
-----------------------------------
"If you're not remembered, then you never existed."

In the world of networking, persistence is survival.
A configuration that vanishes upon restart is a
thought that was never truly committed to memory.

Therefore: Save your iptables. Write your interfaces.
Let your routing tables endure beyond the power cycle.

ARTICLE IV: CONCERNING SECURITY
---------------------------------
Telnet is the glass house of protocols — transparent
to any observer with a packet sniffer.

SSH is the steel vault — its contents visible only
to those who possess the key.

Choose wisely which door you open to The Wired.

---
"No matter where you go, everyone's connected."
— Lain Iwakura
```
Dari node mika, login FTP menggunakan akun mika:
```
ftp 10.73.2.2
# Login: mika / Pass: password
passive
get protocol7_manifesto.txt
put test_mika.txt
bye
```
Hasil dari respon wireshark:
![img](assets/soal(2)_9.png)</br>
![img](assets/soal(1)_9.png)
Proses Download:*cSaat menjalankan perintah download `get protocol7_manifesto.txt` (terdeteksi sebagai perintah FTP `RETR protocol7_manifesto.txt`), server memberikan respon `226 Transfer complete` dengan total file 3479 bytes berhasil diterima[cite: 1].
Proses Upload (Percobaan): Saat mencoba mengunggah file `put test_mika.txt` (terdeteksi sebagai perintah FTP `STOR test_mika.txt`), server menolak aksi tersebut dengan respon `550 Permission denied.`[cite: 1]. Hal ini membuktikan bahwa kebijakan hak akses untuk user `mika` pada FTP Server Chisa berhasil dikonfigurasi secara *read-only*[cite: 1].
**10. Knights melancarkan uji ketahanan koneksi ke server Chisa untuk menguji latensi jaringan The Wired. Kirimkan paket ping dari node Knights ke node Chisa dengan payload khusus 128 bytes dan interval 0.3 detik sebanyak 77 paket (ping -c 77 -s 128 -i 0.3 <IP_Chisa>). Buka Wireshark, catat nilai ICMP Type dan Code untuk Echo Request vs Echo Reply, serta analisis packet loss dan RTT (min/avg/max).
### Penyelesaian: 
Memulai packet capture di Wireshark pada link Knights-Switch 3, selanjutnya membuka console Knights dan jalankan perintah:
```
ping -c 77 -s 128 -i 0.3 10.73.2.2
```
Pada wireshark menerapkan filter icmp dan memeriksa detail Type/Code 
![img](assets/soal(1)_10.png)</br>
![img](assets/soal(2)_10.png)
Pada hasil diatas menunjukan ICMP Request (Knights -> Chisa): Type = 8 dan Code = 0, sedangkan ICMP Reply (Chisa -> Knights): Type = 0 dan Code = 0 untuk Packetloss nya 0% dari (77 dari 77 paket berhasildibalas)
**11. Buktikan kelemahan protokol Telnet dengan membuat akun phantom_user dan password wired_ghost pada layanan telnetd di node Chisa. Lakukan login Telnet dari node Eiri ke node Chisa dan tangkap sesi menggunakan Wireshark. Tunjukkan kredensial plain text melalui fitur Follow TCP Stream, serta jelaskan mengapa setiap karakter terkirim dalam paket TCP terpisah.**
### Penyelesaian:
Pertama-tama kita perlu menjalankan beberapa command pada konsol Node Client Chisa.
```bash
apk update
apk add busybos-extras
adduser -D phantom_user
echo "phantom_user:wired_ghost" | chpasswd
telnetd -F -p 23 &
```
Kemudian kita bisa memilih `Start capture` pada kabel penghubung node Eiri dan switch. Buka konsol Node Client Eiri dan hubungi IP Node Client Chisa.
```
telnet 10.73.2.2 23
whoami
```
![img](assets/Soal_11-1.png)<br>
![img](assets/Soal_11-2.png)<br>
![img](assets/Soal_11-3.png)<br>
![img](assets/Soal_11-4.png)
Hal ini terjadi karena protokol Telnet menggunakan mekanisme Remote Echo, di mana server mengirimkan kembali (echo) setiap karakter yang diketik pengguna agar tampil di layar terminal. Ketika Wireshark menggabungkan alur lalu lintas dua arah ke dalam TCP Stream, karakter asli yang diketik client (merah) bersanding langsung dengan karakter balasan dari server (biru) sehingga huruf terlihat ganda. Sementara pada masukan Password, server sengaja mematikan fitur echo demi keamanan, sehingga hanya data asli dari client yang terekam dan hurufnya tidak mengganda (wired_ghost).<br>
**12. Alice mencurigai Knights menjalankan beberapa layanan rahasia di node-nya. Lakukan pemindaian port dari node Alice ke node Knights menggunakan Netcat (nc) untuk memeriksa port 22 (SSH) dan 80 (HTTP) dalam keadaan terbuka, serta port rahasia 7777 dalam keadaan tertutup. Analisis di Wireshark perbedaan TCP Flag yang dikembalikan antara port terbuka (SYN-ACK) dengan port tertutup (RST-ACK).**
### Penyelesaian:
Soal ini bisa diselesaikan dengan mendownload dan menyalakan service pada Node Client Knights terlebih dahulu.
```bash
apk update
apk add openssh lighttpd busybox-extras
ssh-keygen -A
/usr/sbin/sshd
lighttpd -f /etc/lighttpd/lighttpd.conf
```
Kemudian bisa dilanjutkan dengan `Start capture` pada kabel yang menghubungkan Alice dan Switch 1. Selanjutnya bisa melakukan Netcat pada Node Client Alice
```bash
nc -zv -w 2 10.73.3.2 22
nc -zv -w 2 10.73.3.2 80
nc -zv -w 2 10.73.3.2 7777
```
Seharusnya akan muncul seperti ini
```bash
Alice:~# nc -zv -w 2 10.73.3.2 22
10.73.3.2 (10.73.3.2:22) open
Alice:~# nc -zv -w 2 10.73.3.2 80
10.73.3.2 (10.73.3.2:80) open
Alice:~# nc -zv -w 2 10.73.3.2 7777
nc: connect to 10.73.3.2 port 7777 (tcp) failed: Connection refused
```
![img](assets/Soal_12.png)<br>
Analisis:
- Port terbuka: Port 80 (HTTP). Paket No. 20 - Alice (10.73.1.2) mengirim `[SYN]` ke port 80. Paket No. 21 (Balasan) - Knights(10.73.3.2) membalas dengan `[SYN, ACK]` yang berarti port 80 terbuka dan menerima koleksi.
- Port tertutup: Port 777. Paket No. 28 - Alice (10.73.1.2) mengirim `[SYN]` ke port 777. Paket No. 29 membalas dengan `[RST, ACK]` yang berarti tertutup atau koneksi ditolak.
- Port terbuka berwarna hijau, port tertutup berwarna merah.
**13. Lain memerintahkan agar administrasi jarak jauh menggunakan SSH secara aman tanpa password. Install OpenSSH server pada node Knights, buat pasangan kunci SSH (ssh-keygen) pada node Mika untuk user mika_admin, dan konfigurasikan public key authentication (PasswordAuthentication no). Lakukan koneksi SSH dari node Mika ke node Knights, tangkap sesi menggunakan Wireshark, identifikasi paket Protocol Version Exchange dan Key Exchange, serta jelaskan mengapa kredensial tidak terlihat dalam bentuk teks terbuka seperti pada Telnet.**
### Penyelesaian:
Soal ini dapat diselesaikan dengan menjalankan beberapa command pada Node Client Knights sebagai berikut:
```bash
apk update
apk add openssh

ssh-keygen -A

adduser -D mika_admin

mkdir -p /home/mika_admin/.ssh
touch /home/mika_admin/.ssh/authorized_keys
chmod 700 /home/mika_admin
chmod 700 /home/mika_admin/.ssh
chmod 600 /home/mika_admin/.ssh/authorized_keys
chown -R mika_admin:mika_admin /home/mika_admin

sed -i '/PasswordAuthentication/d' /etc/ssh/sshd_config
sed -i '/PubkeyAuthentication/d' /etc/ssh/sshd_config
sed -i '/StrictModes/d' /etc/ssh/sshd_config
sed -i '/AuthorizedKeysFile/d' /etc/ssh/sshd_config

echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "StrictModes no" >> /etc/ssh/sshd_config
echo "AuthorizedKeysFile /home/mika_admin/.ssh/authorized_keys" >> /etc/ssh/sshd_config

/usr/sbin/sshd
```
Kemudian buka konsol Node Client Mika dan jalankan
```bash
apk update
apk add openssh-client

rm -rf ~/.ssh

ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""

cat ~/.ssh/id_rsa.pub
```
Didapatkan public key:
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSOp/qYFfiO4bap6PLqVU4Ecbx0554DEHKUgdmUVf/X8TsUDxE011KvwHjj3PPBFVqHjokGWTTyjE69bs6dP2P17nMm0ESYUqTK0S4+yNpCQXxNvwkaH8GjdSKRUnZeVLH1gVt2AESpwaV3b+LoNyaZUikkVH7Qhw0AHOePTW2q/icW3qvaz4H6ZdWffqSFHSHDCVip9W87aBCrkw/ITr2UWcT9gu3poGdPstm//goQs+Ci5OvhH9WD97QA/9DEqIw49oSjFSCjBuN/nwTku0PiY3zYakFSe0IW/kQQYH+x4y6t3N4NDxjzF8JBIgpQr/0Jks+PPX/2meax6T2cjRb root@Mika
```
Kembali lagi ke Node Client Knights dan jalankan
```bash
cat << 'EOF' > /home/mika_admin/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSOp/qYFfiO4bap6PLqVU4Ecbx0554DEHKUgdmUVf/X8TsUDxE011KvwHjj3PPBFVqHjokGWTTyjE69bs6dP2P17nMm0ESYUqTK0S4+yNpCQXxNvwkaH8GjdSKRUnZeVLH1gVt2AESpwaV3b+LoNyaZUikkVH7Qhw0AHOePTW2q/icW3qvaz4H6ZdWffqSFHSHDCVip9W87aBCrkw/ITr2UWcT9gu3poGdPstm//goQs+Ci5OvhH9WD97QA/9DEqIw49oSjFSCjBuN/nwTku0PiY3zYakFSe0IW/kQQYH+x4y6t3N4NDxjzF8JBIgpQr/0Jks+PPX/2meax6T2cjRb root@Mika
EOF

chmod 600 /home/mika_admin/.ssh/authorized_keys
chown -R mika_admin:mika_admin /home/mika_admin/.ssh
```
Lanjut lagi ke Node Client Mika dan jalankan
```bash
ssh -i ~/.ssh/id_rsa mika_admin@10.73.3.2
```
![img](assets/Soal_13-1.png)<br>
![img](assets/Soal_13-2.png)<br>
![img](assets/Soal_13-3.png)<br>
### Protocol Version Exchange:
**Paket**: Terletak di bagian paling awal alur SSH.<br>
**Tampilan Kolom Info**:<br>
- **Client**: `Protocol (SSH-2.0-OpenSSH_10.2)`
- **Server**: `Protocol (SSH-2.0-OpenSSH_10.2)`
<br> **Fungsi**: Kedua node (Mika dan Knights) saling menyapa dan memverifikasi bahwa keduanya menggunakan versi protokol yang sama (SSHv2).
### Key Exchange (KEX):
**Paket**: Berada tepat setelah Protocol Version Exchange.<br>
**Tampilan Kolom Info**:<br>
- `SSH2_MSG_KEXINIT`
- `SSH2_MSG_KEX_ECDH_INIT / SSH2_MSG_KEX_ECDH_REPLY`
<br> **Fungsi**: Mika dan Knights menyepakati algoritma enkripsi (seperti AES atau ChaCha20-Poly1305) serta melakukan pertukaran kunci simetris (shared secret key) secara aman menggunakan metode Diffie-Hellman tanpa mengirimkan kunci asli melewati jaringan.
**14. Setelah gagal mengakses FTP, Eiri melancarkan serangan brute-force terhadap form login web Alice. Analisis file capture wired_bruteforce.pcapng untuk mengidentifikasi alamat IP penyerang, target IP beserta port yang diserang, password user lain_admin yang berhasil ditembus, serta web server software dan versi yang dilaporkan pada response header. Validasi temuan kalian pada socket server: (link file) nc [IP_Group] 3401
### Penyelesaian:
Pertama jalankan command berikut di konsol untuk mendapatkan soal
```bash
nc 10.4.89.246 3401
```
Kemudian buka file yang terdapat pada drive di Wireshark. Pada wireshark dapat dilihat sebuah IP menyerang IP lainnya. Untuk mendapatkan jawaban dari soal-soal yang ada pada `nc 10.4.89.246 3401`, kita perlu melakukan beberapa filter pada Wireshark.<br>
![img](assets/Soal_14-1.png)<br>
![img](assets/Soal_14-3.png)<br>
![img](assets/Soal_14-4.png)<br>
![img](assets/Soal_14-6.png)<br>
Kemudian bisa didapatkan jawaban ssebagai brikut:
![img](assets/Soal_14-7.png)

**15. Eiri menyusup ke ruang server dan memasang perangkat keyboard USB berbahaya pada node Alice. Buka file capture wired_usb_hid.pcap, identifikasi Vendor ID dan Product ID perangkat USB dari deskriptor USB, alamat nomor device USB, serta pesan rahasia yang berhasil dicuri dari keystroke. Validasi temuan kalian pada socket server: (link file) nc [IP_Group] 3402 
### Penyelesaian:
Pertama jalankan command berikut di konsol untuk mendapatkan soal
```bash
nc 10.4.89.246 3402
```
Kemudian download file dan dan buka file soal no. 15 pada Wireshark. Lakukan beberapa filter pada Wireshark seperti berikut:
![img](assets/Soal_15-1.png)<br>
![img](assets/Soal_15-2.png)<br>
Setelah itu cari password dengan command berikut:
```
 & "C:\Program Files\Wireshark\tshark.exe" -r "$env:USERPROFILE\Downloads\soal15_wired_usb_hid.pcap" -Y "usb.capdata" -T fields -e usb.capdata
```
Kemudian decode menggunakan `decode_hid.py`
```py
import sys

hid_map = {
    0x04: ('a', 'A'), 0x05: ('b', 'B'), 0x06: ('c', 'C'), 0x07: ('d', 'D'),
    0x08: ('e', 'E'), 0x09: ('f', 'F'), 0x0a: ('g', 'G'), 0x0b: ('h', 'H'),
    0x0c: ('i', 'I'), 0x0d: ('j', 'J'), 0x0e: ('k', 'K'), 0x0f: ('l', 'L'),
    0x10: ('m', 'M'), 0x11: ('n', 'N'), 0x12: ('o', 'O'), 0x13: ('p', 'P'),
    0x14: ('q', 'Q'), 0x15: ('r', 'R'), 0x16: ('s', 'S'), 0x17: ('t', 'T'),
    0x18: ('u', 'U'), 0x19: ('v', 'V'), 0x1a: ('w', 'W'), 0x1b: ('x', 'X'),
    0x1c: ('y', 'Y'), 0x1d: ('z', 'Z'), 0x1e: ('1', '!'), 0x1f: ('2', '@'),
    0x20: ('3', '#'), 0x21: ('4', '$'), 0x22: ('5', '%'), 0x23: ('6', '^'),
    0x24: ('7', '&'), 0x25: ('8', '*'), 0x26: ('9', '('), 0x27: ('0', ')'),
    0x2c: (' ', ' '), 0x2d: ('-', '_'), 0x2e: ('=', '+')
}

output = []
for line in sys.stdin:
    line = line.strip()
    if not line or len(line) < 6:
        continue
    
    modifier = int(line[0:2], 16)
    keycode = int(line[4:6], 16)
    
    if keycode in hid_map:
        is_shift = bool(modifier & 0x22)
        char = hid_map[keycode][1] if is_shift else hid_map[keycode][0]
        output.append(char)

print("\nHasil Pesan Rahasia: " + "".join(output))
```
Didapatkan hasil sebagai berikut
![img](assets/Soal_15-3.png)<br>
![img](assets/Soal_15-4.png)<br><br>
**16. Eiri meletakkan file malware di server. Dari file capture wired_ftp_theft.pcapng, lakukan analisis lalu lintas FTP untuk mengidentifikasi alamat IP server FTP penyerang, banner software FTP yang digunakan, kredensial login penyerang, serta ukuran (size in bytes) dari file malware knights_payload.exe yang diunduh. Validasi temuan kalian pada socket server: nc [IP_Group] 3403.
### Penyelesaian
Membuka file `wired_ftp_theft.pcapng` menggunakan Wireshark, kemudia menerapkan display filter: 
```
ftp
```
Pada capture ditemukan dua sesi FTP berbeda: sesi pertama menggunakan akun `alice` yang bersifat umpan (decoy) dan tidak berkaitan langsung dengan malware, sedangkan sesi kedua menggunakan akun `knights_agent` yang benar-benar melakukan pengunduhan file malware. Bukti ukuran file ditemukan pada perintah `SIZE` dan `RETR` terhadap `knights_payload.exe`:<br>
![img](assets/soal(1)_16.png)<br>
Hasil analisis:
- **IP address FTP server**: `198.51.100.7`
- **Banner FTP server**: `vsftpd 3.0.5` (*Welcome to Wired FTP Server*)
- **Kredensial login penyerang**: `knights_agent : N4v1_s3cur3_2026`
- **Ukuran file knights_payload.exe**: `524288 bytes`
Validasi jawaban dilakukan pada socket server:
```bash
nc 10.4.89.246 3403
```
![img](assets/soal(2)_16.png)<br>
Flag yang diperoleh: `KOMJAR26{FTP_Th3ft_POVgcYsMLxl0AUQYkic49Wmdi}`

**17. Alice membuat halaman web di node-nya. Eiri memanfaatkan celah untuk mengunduh payload berbahaya ke sistem Alice. Analisis file capture wired_http_c2.pcap untuk mengidentifikasi nama domain (Host) tempat malware diunduh, alamat IP server penyerang, nama file executable malware yang diunduh, serta kode status HTTP yang dikembalikan. Validasi temuan kalian pada socket server: nc [IP_Group] 3404
### Penyelesaian
Membuka file `wired_http_c2.pcap` menggunakan Wireshark, kemudian menerapkan display filter:
```
http
```
Ditemukan dua sesi HTTP berbeda: traffic normal (halaman web Alice beserta `style.css`) dan traffic mencurigakan berupa permintaan `GET /navi_agent.exe`:<br>
![img](assets/soal(1)_17.png)<br>
Detail request dan response dilihat melalui `Follow → HTTP Stream`:
```
GET /navi_agent.exe HTTP/1.1
Host: wired-update.net
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)
 
HTTP/1.1 200 OK
Server: nginx/1.24.0
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="navi_agent.exe"
 
MZ...This program cannot be run in DOS mode...
```
Hasil analisis:
- **Nama domain (Host)**: `wired-update.net`
- **IP address server penyerang**: `203.0.113.42`
- **Nama file executable malware**: `navi_agent.exe`
- **Kode status HTTP**: `200 OK`
Signature `MZ...This program cannot be run in DOS mode` pada body response mengonfirmasi bahwa file yang diunduh merupakan file executable Windows (format PE).
 
Validasi jawaban dilakukan pada socket server:
```bash
nc 10.4.89.246 3404
```
![img](assets/soal(2)_17.png)<br>
Flag yang diperoleh: `KOMJAR26{Navi_C2_D0wnl04d_mevweP0KVZWZg8cBWYqZtgHwh}`
**18. Eiri mengubah taktik penyerangan dengan menanamkan file malware menggunakan protokol file sharing SMB. Analisis file capture wired_smb_transfer.pcapng untuk mengidentifikasi nama protokol jaringan yang dieksploitasi, IP pengirim dan penerima, folder tujuan penyimpanan malware pada sistem korban, serta nama file executable malware yang ditransfer. Validasi temuan kalian pada socket server: nc [IP_Group] 3405
### Penyelesaian
Membuka file `wired_smb_transfer.pcapng` menggunakan Wireshark, kemudian menerapkan display filter:
```
smb2
```
Ditelusuri urutan operasi SMB2 mulai dari Negotiate Protocol, Session Setup, Tree Connect, hingga Create Request dan Write Request:<br>
![img](assets/soal(1)_18.png)<br>
Hasil analisis:
- **Protokol yang dieksploitasi**: `SMB2` (*Server Message Block* versi 2)
- **IP pengirim (penyerang)**: `10.7.3.100`
- **IP penerima (korban)**: `10.7.1.50`
- **Target share/direktori**: `ADMIN$` (path lengkap: `ADMIN$\System32\wired_trojan_payload.exe`)
- **Nama file malware**: `wired_trojan_payload.exe`
Validasi jawaban dilakukan pada socket server:
```bash
nc 10.4.89.246 3405
```
![img](assets/soal(2)_18.png)<br>
Flag yang diperoleh: `KOMJAR26{SMB_Tr4nsf3r_ABGxWa6A4YGXM0fMJVk4e9zMm}`
**19. Eiri meneror jaringan dengan mengirimkan email pemerasan melalui protokol SMTP tanpa enkripsi. Analisis file capture wired_smtp_threat.pcap pada stream TCP terkait, identifikasi alamat email korban yang ditargetkan, password korban yang diklaim bocor oleh penyerang, jenis malware yang diinfeksikan, batas waktu (dalam hari) yang diberikan, serta MailClientID yang tercantum pada pesan. Validasi temuan kalian pada socket server: nc [IP_Group] 3406
### Penyelesaian
Membuka file `wired_smtp_threat.pcap` menggunakan Wireshark, kemudian menerapkan display filter:
```
smtp
```
Ditemukan beberapa TCP stream SMTP — salah satunya berupa email normal (laporan mingguan biasa), sedangkan stream lain berisi email pemerasan. Isi lengkap email dilihat melalui `Follow → TCP Stream`:
![img](assets/soal(2)_19.png)
Hasil analisis:
- **Alamat email korban**: `victim@protocol7.co.jp`
- **Password yang diklaim bocor**: `pr0tocol_7_user`
- **Jenis malware**: `ransomware`
- **Batas waktu**: `3` hari (72 jam)
- **MailClientID**: `7719980706`
Validasi jawaban dilakukan pada socket server:
```bash
nc 10.4.89.246 3406
```
![img](assets/soal(2)_19.png)<br>
Flag yang diperoleh: `KOMJAR26{SMTP_Ext0rt10n_vGZjtLTkhwp8q00Lz5n35qb6k}`
**20. nMembuka file `wired_tls_decrypt.pcapng` menggunakan Wireshark. Sebelum dianalisis, terlebih dahulu dilakukan konfigurasi TLS decryption melalui `Edit → Preferences → Protocols → TLS`, kemudian mengisi field **"(Pre)-Master-Secret log filename"** dengan file `keyslogfile.txt` yang telah disediakan.
 
Setelah keylog diterapkan, seluruh sesi TLS pada stream ini difilter menggunakan:
```
tls
```
![img](assets/soal(1)_20.png)<br>
Terlihat urutan TLS handshake lengkap (`Client Hello (SNI=example.com)`, `Server Hello`, `Certificate`, `Client Key Exchange`, `Change Cipher Spec`), diikuti oleh paket `Application Data` yang semula terenkripsi namun berhasil didekripsi menjadi paket **HTTP** yang dapat dibaca langsung pada paket No. 6 dan No. 7:
```
6   HTTP   HEAD / HTTP/1.1
7   HTTP   HTTP/1.1 200 OK
```
Keberhasilan dekripsi juga dapat dikonfirmasi melalui tab **"Decrypted TLS"** yang muncul pada panel detail paket (di samping tab "Packet"), menandakan Wireshark berhasil membaca isi asli data yang terenkripsi menggunakan kunci sesi dari `keyslogfile.txt`.
 
Detail lengkap request dan response dilihat melalui `Follow → HTTP Stream` pada paket No. 6:
```
HEAD / HTTP/1.1
Host: example.com
User-Agent: curl/7.62.0
Accept: */*
 
HTTP/1.1 200 OK
Server: ECS (dca/24CE)
Content-Type: text/html; charset=UTF-8
```
Hasil analisis:
- **Versi protokol TLS**: `TLS 1.2`
- **Domain (SNI)**: `example.com`
- **IP server HTTPS**: `93.184.216.34`
- **User-Agent**: `curl/7.62.0`
- **HTTP request method & path**: `HEAD /`
Validasi jawaban dilakukan pada socket server:
```bash
nc 10.4.89.246 3407
```
![img](assets/soal(2)_20.png)<br>
Flag yang diperoleh: `KOMJAR26{TLS_D3crypt_xUpIVuEYjQUsJMunWmR7sPj2k}`