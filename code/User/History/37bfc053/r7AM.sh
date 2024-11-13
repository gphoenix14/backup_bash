#!/bin/bash

# Mostra il numero di CPU logiche e fisiche all'inizio
echo "Informazioni CPU:"
lscpu | grep -E '^CPU\(s\):|^Socket\(s\):'

# Messaggio iniziale
echo ""
echo "Monitoraggio in tempo reale (aggiornato ogni 2 secondi). Premere Ctrl + C per uscire."

# Loop per aggiornare le informazioni ogni 2 secondi
while true; do
    # Pulisce lo schermo
    clear

    # Mostra il numero di CPU logiche e fisiche
    echo "Informazioni CPU:"
    lscpu | grep -E '^CPU\(s\):|^Socket\(s\):'
    echo "----------------------------------------"

    # Utilizzo delle CPU
    echo "Utilizzo delle CPU:"
    mpstat -P ALL 1 1

    # Utilizzo della RAM
    echo ""
    echo "Utilizzo della RAM:"
    free -h

    # Carico medio del sistema
    echo ""
    echo "Carico medio del sistema:"
    uptime

    # Pausa di 2 secondi prima del prossimo aggiornamento
    sleep 5
done
