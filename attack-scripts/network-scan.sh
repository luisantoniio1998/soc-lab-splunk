#!/bin/bash

# Network Scanning Simulation Script
# Simulates reconnaissance and scanning activities

echo "===== Network Scanning Simulation ====="
echo ""

# Check if nmap is installed
if ! command -v nmap &> /dev/null; then
    echo "[!] Installing nmap..."
    apt-get update -qq && apt-get install -y nmap &> /dev/null
fi

# Port scanning
echo "[+] Simulating port scanning..."
nmap -p 80,443,3306,22,8000 webserver 2>/dev/null | head -20
sleep 2

echo "[+] Simulating service version detection..."
nmap -sV webserver -p 80 2>/dev/null | head -15
sleep 2

echo "[+] Simulating OS detection..."
nmap -O webserver 2>/dev/null | head -15
sleep 2

# Ping sweep
echo "[+] Simulating ping sweep..."
nmap -sn 172.25.0.0/24 2>/dev/null | grep "Nmap scan report"
sleep 2

echo "[+] Simulating aggressive scan..."
nmap -A ubuntu-target -p 22,80 2>/dev/null | head -20
sleep 2

echo ""
echo "===== Scanning Simulation Complete ====="
