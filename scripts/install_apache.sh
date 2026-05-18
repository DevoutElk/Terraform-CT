#!/bin/bash
set -e  # para si hay error

echo "==> Instalando Apache2..."
apt update
apt install -y apache2
systemctl enable apache2
systemctl start apache2

echo "==> Frontend listo!"
