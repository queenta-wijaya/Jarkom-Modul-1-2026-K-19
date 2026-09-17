#buat file cek_status.sh
nano /root/cek_status.sh

#isi file
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

#jalankan file cek_status.sh
chmod +x /root/cek_status.sh
/root/cek_status.sh