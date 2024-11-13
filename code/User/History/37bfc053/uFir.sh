#!/bin/bash

# Mostra il numero di CPU logiche e fisiche
echo "Informazioni CPU:"
lscpu | grep -E '^CPU\(s\):|^Socket\(s\):'

echo ""
echo "Monitoraggio in tempo reale (aggiornato ogni 2 secondi)."

# Loop per aggiornare le informazioni
while true; do
    echo "----------------------------------------"
    echo "Utilizzo delle CPU:"
    mpstat -P ALL 1 1

    echo ""
    echo "Utilizzo della RAM:"
    free -h

    echo ""
    echo "Carico medio del sistema:"
    uptime

    echo ""
    sleep 2
done
