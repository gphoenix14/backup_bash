#!/bin/bash

#Verifica se è stata passata un'interfaccia di rete come argomento
if [ -z "$1" ]; then 
    echo "Utilizzo : $0 <interfaccia di rete>"
    echo "Esempio: $0 eth0"
    exit 1
fi

INTERFACE="$1"
INTERVAL=1 #intervallo di aggiornamento in secondi

#Variabili per contatori
total_received_mb=0
total_transmitted_mb=0

#Funzione per ottenere i byte ricevuti e trasmessi
get_bytes() {
    rx_bytes=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    tx_bytes=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
}

#Otteniamo i byte iniziali
get_bytes
prev_rx_bytes=$rx_bytes
prev_tx_bytes=$tx_bytes
