#!/bin/bash

# Mostra il numero di CPU logiche e fisiche una volta all'inizio
echo "Informazioni CPU:"
lscpu | grep -E '^CPU\(s\):|^Socket\(s\):'
echo ""
echo "Monitoraggio in tempo reale (aggiornato ogni 2 secondi). Premere Ctrl + C per uscire."

# Funzione per aggiornare le informazioni sullo schermo
update_info() {
    # Posiziona il cursore all'inizio della riga
    tput cup 3 0

    # Utilizzo delle CPU
    echo "Utilizzo delle CPU:"
    mpstat -P ALL 1 1 | tail -n +4 | head -n -1

    # Posiziona il cursore sotto la sezione delle CPU
    tput cup 14 0

    # Utilizzo della RAM
    echo "Utilizzo della RAM:"
    free -h

    # Carico medio del sistema
    tput cup 19 0
    echo "Carico medio del sistema:"
    uptime
}

# Loop per aggiornare le informazioni ogni 2 secondi
while true; do
    update_info
    sleep 2
done
