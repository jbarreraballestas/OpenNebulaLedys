#!/bin/bash

# Mostrar version de ubuntu del sistema
lsb_release -a

# Mostrar usuario
whoami

# Obtener la version de ubuntu del sistema
ubuntu_version=$(lsb_release -sr)

# Actualizar repositorios de ubuntu
apt-get update

# Instalar paquetes necesarios
apt-get -y install gnupg wget apt-transport-https

# Agregar llave de acceso a repositorios de OpenNebula
wget -q -O- https://downloads.opennebula.io/repo/repo2.key | gpg --dearmor --yes --output /etc/apt/keyrings/opennebula.gpg

# Agregar el archivo de repositorio segun la version de ubuntu
echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://downloads.opennebula.io/repo/6.10/Ubuntu/$ubuntu_version stable opennebula" > /etc/apt/sources.list.d/opennebula.list

# Actualizar repositorios con paquetes de OpenNebula agregados arriba
apt-get update

# Instalar paquetes de OpenNebula y servicios
apt-get -y install opennebula opennebula-fireedge opennebula-gate opennebula-flow opennebula-provision

# Cambiar contraseña de oneadmin con la estructura usuario:contraseña o dejar comentado para usar la contraseña autogenerada
#echo 'oneadmin:miContraseña123' > /var/lib/one/.one/one_auth

# Iniciar los servicios de OpenNebula
systemctl start opennebula opennebula-fireedge opennebula-gate opennebula-flow

# Verificar la instalación
oneuser show

# Mostrar la url de acceso
echo "Inicia sesión en: http://127.0.0.1:2616/fireedge/sunstone"

# Obtener el usuario y contraseña
user_pass=$(cat /var/lib/one/.one/one_auth)

# Mostrar usuario y contraseña generada durante la instalación
echo "Usuario y contraseña: $user_pass"

# Instalar herramientas de red
apt install net-tools
