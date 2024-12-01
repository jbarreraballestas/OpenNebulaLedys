#!/bin/bash

# Mostrar version de ubuntu del sistema
lsb_release -a

# Mostrar usuario
whoami

# Obtener la version de ubuntu del sistema
ubuntu_version=$(lsb_release -sr)

# Actualizar repositorios de ubuntu
apt update

# Actualizar paquetes de ubuntu
apt upgrade -y

# Instalar paquetes necesarios
apt -y install gnupg wget apt-transport-https

# Agregar llave de acceso a repositorios de OpenNebula
wget -q -O- https://downloads.opennebula.io/repo/repo2.key | gpg --dearmor --yes --output /etc/apt/keyrings/opennebula.gpg

# Agregar el archivo de repositorio segun la version de ubuntu
echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://downloads.opennebula.io/repo/6.10/Ubuntu/$ubuntu_version stable opennebula" > /etc/apt/sources.list.d/opennebula.list

# Actualizar repositorios con paquetes de OpenNebula agregados arriba
apt update

# Instalar paquetes de OpenNebula y servicios
apt -y install opennebula opennebula-fireedge opennebula-gate opennebula-flow opennebula-provision

# Cambiar contraseña de oneadmin con la estructura usuario:contraseña o dejar comentado para usar la contraseña autogenerada
#echo 'oneadmin:miContraseña123' > /var/lib/one/.one/one_auth

# Habilitar e iniciar los servicios de OpenNebula
systemctl enable --now opennebula opennebula-fireedge opennebula-gate opennebula-flow

# Verificar la instalación
oneuser show

# Mostrar las posibles urls de acceso
echo "Inicia sesión en alguna de las siguientes direcciones:"
ip -o -4 addr show | awk '{print "https://" substr($4, 1, index($4, "/")-1) ":2616/fireedge/sunstone"}'

# Obtener el usuario y contraseña
user_pass=$(cat /var/lib/one/.one/one_auth)

# Mostrar usuario y contraseña generada durante la instalación
echo "Usuario y contraseña: $user_pass"

# Instalar herramientas de red
apt install net-tools

# Instalar herramienta de verificación de virtualización
apt install cpu-checker -y
kvm-ok


