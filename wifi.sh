#!/bin/bash

# Función para poner la tarjeta Wi-Fi en modo monitor
activar_modo_monitor() {
    echo "[+] Deshabilitando servicios de red..."
    sudo systemctl stop NetworkManager
    sudo systemctl stop wpa_supplicant
    
    echo "[+] Deshabilitando Ethernet (si está habilitado)..."
    sudo ifconfig eth0 down 2>/dev/null

    echo "[+] Listando interfaces de red disponibles..."
    iwconfig

    echo "[+] Introduce el nombre de tu tarjeta Wi-Fi (ej. wlan0):"
    read interface

    echo "[+] Deshabilitando la interfaz Wi-Fi..."
    sudo ifconfig $interface down

    echo "[+] Activando modo monitor en $interface..."
    sudo iwconfig $interface mode monitor

    echo "[+] Rehabilitando la interfaz Wi-Fi..."
    sudo ifconfig $interface up

    echo "[+] Confirmando que la interfaz está en modo monitor..."
    iwconfig $interface
}

# Función para devolver la tarjeta Wi-Fi al modo administrado
desactivar_modo_monitor() {
    echo "[+] Introduce el nombre de tu tarjeta Wi-Fi (ej. wlan0mon):"
    read interface

    echo "[+] Deshabilitando la interfaz Wi-Fi..."
    sudo ifconfig $interface down

    echo "[+] Cambiando el modo de la interfaz a administrado..."
    sudo iwconfig $interface mode managed

    echo "[+] Rehabilitando la interfaz Wi-Fi..."
    sudo ifconfig $interface up

    echo "[+] Habilitando servicios de red..."
    sudo systemctl start NetworkManager
    sudo systemctl start wpa_supplicant

    echo "[+] Activando Ethernet (si estaba deshabilitada)..."
    sudo ifconfig eth0 up 2>/dev/null
    
    echo "[+] La interfaz ha vuelto al modo administrado."
    iwconfig $interface
}

# Función para ejecutar herramientas de la suite de Aircrack-ng
ejecutar_aircrack() {
    echo "[+] Introduce el canal a escanear (ej. 1, 6, 11):"
    read canal
    echo "[+] Introduce el BSSID de la red objetivo (ej. XX:XX:XX:XX:XX:XX):"
    read bssid
    echo "[+] Introduce la interfaz en modo monitor (ej. wlan0mon):"
    read interface_monitor

    echo "[+] Iniciando airodump-ng..."
    sudo airodump-ng -c $canal --bssid $bssid $interface_monitor
}

# Menú del script
opciones() {
    echo "===================================="
    echo "   Script para la Suite Aircrack-ng"
    echo "===================================="
    echo "1) Activar modo monitor"
    echo "2) Ejecutar Aircrack-ng"
    echo "3) Desactivar modo monitor"
    echo "4) Salir"
    echo "===================================="
    echo "Elige una opción:"
}

# Bucle principal del menú
while true; do
    opciones
    read opcion
    case $opcion in
        1) activar_modo_monitor ;;
        2) ejecutar_aircrack ;;
        3) desactivar_modo_monitor ;;
        4) echo "Saliendo..."; exit ;;
        *) echo "Opción no válida";;
    esac
done
