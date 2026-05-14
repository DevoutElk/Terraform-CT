#!/bin/bash
set -e

echo "==> Instalando MariaDB..."
apt update
DEBIAN_FRONTEND=noninteractive apt install -y mariadb-server
systemctl enable mariadb
systemctl start mariadb

echo "==> Backend listo!"