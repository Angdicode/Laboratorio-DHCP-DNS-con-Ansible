#!/bin/bash
# Script de validación para ejecutar dentro del cliente Vagrant

echo "[*] Detectando interfaz de red interna (eth1/enp0s8)..."
INTERFACE=$(ip link | grep -E 'eth1|enp0s8' | awk '{print $2}' | tr -d ':')

if [ -z "$INTERFACE" ]; then
    echo "[!] No se encontró la interfaz secundaria."
    exit 1
fi

echo "[*] Levantando interfaz $INTERFACE y solicitando DHCP..."
sudo ip link set $INTERFACE up
sudo dhclient -v $INTERFACE

echo "[*] Verificando concesión de IP..."
ip -4 addr show $INTERFACE

echo "[*] Verificando resolución DNS local (server.lab.local)..."
dig @192.168.33.10 server.lab.local +short

echo "[*] Verificando resolución DNS externa (google.com) vía Forwarder..."
dig @192.168.33.10 google.com +short