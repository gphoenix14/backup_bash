#!/bin/bash

# Verifica se è stata passata un'interfaccia come argomento
if [ -z "$1" ]; then
    echo "Utilizzo: $0 <interfaccia di rete>"
    echo "Esempio: $0 eth0"
    exit 1
fi

INTERFACE="$1"
INTERVAL=1  # Intervallo di aggiornamento in secondi

# Variabili per contatori
total_received_mb=0
total_transmitted_mb=0

# Funzione per ottenere i byte ricevuti e trasmessi
get_bytes() {
    rx_bytes=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    tx_bytes=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
}

# Ottieni i byte iniziali
get_bytes
prev_rx_bytes=$rx_bytes
prev_tx_bytes=$tx_bytes

# Loop infinito per monitorare il traffico
while true; do
    sleep $INTERVAL

    # Ottieni i byte correnti
    get_bytes

    # Calcola la differenza in byte e converti in KB
    rx_diff=$((rx_bytes - prev_rx_bytes))
    tx_diff=$((tx_bytes - prev_tx_bytes))

    rx_kb=$((rx_diff / 1024))
    tx_kb=$((tx_diff / 1024))

    # Aggiorna i contatori totali in MB
    total_received_mb=$((total_received_mb + rx_diff / 1024 / 1024))
    total_transmitted_mb=$((total_transmitted_mb + tx_diff / 1024 / 1024))

    # Mostra la quantità di traffico in tempo reale e totale
    echo "Interfaccia: $INTERFACE"
    echo "Ricevuti: ${rx_kb} KB/s | Inviati: ${tx_kb} KB/s"
    echo "Totale Ricevuti: ${total_received_mb} MB | Totale Inviati: ${total_transmitted_mb} MB"
    echo "-----------------------------------------"

    # Aggiorna i valori precedenti
    prev_rx_bytes=$rx_bytes
    prev_tx_bytes=$tx_bytes
done
