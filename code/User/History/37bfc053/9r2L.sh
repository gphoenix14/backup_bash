#!/bin/bash

# Inizializza lo schermo e prepara la visualizzazione
echo "Monitoraggio in tempo reale (aggiornato ogni 2 secondi). Premere Ctrl + C per uscire."

# Mostra le intestazioni una sola volta
echo "----------------------------------------"
echo "Informazioni CPU:"
lscpu | grep -E '^CPU\(s\):|^Socket\(s\):'
echo "----------------------------------------"
echo -e "CPU  | Utilizzo (%) di idle"
echo "---------------------------"
echo "CPU 0: "
echo "CPU 1: "
echo "CPU 2: "
echo "CPU 3: "
echo "----------------------------------------"
echo "Utilizzo RAM:"
echo "Memoria libera: "
echo "Swap libero: "
echo "----------------------------------------"
echo "Carico medio del sistema:"

# Funzione per aggiornare i valori specifici
update_info() {
    # Ottieni l'utilizzo di ogni CPU (idle %)
    cpu_idle=$(mpstat -P ALL 1 1 | grep -E 'all|CPU' -v | awk '{print $12}')

    # Aggiorna il valore di ogni CPU
    index=0
    for idle in $cpu_idle; do
        tput cup $((8 + index)) 10
        printf "%-10s" "$idle %"
        index=$((index + 1))
    done

    # Aggiorna le informazioni sulla RAM
    ram_free=$(free -h | grep Mem | awk '{print $4}')
    swap_free=$(free -h | grep Swap | awk '{print $4}')
    tput cup 13 20
    printf "%-10s" "$ram_free"
    tput cup 14 20
    printf "%-10s" "$swap_free"

    # Aggiorna il carico medio del sistema
    load_avg=$(uptime | awk -F'load average:' '{print $2}')
    tput cup 16 25
    printf "%-20s" "$load_avg"
}

# Loop per aggiornare le informazioni ogni 2 secondi
while true; do
    update_info
    sleep 2
done
