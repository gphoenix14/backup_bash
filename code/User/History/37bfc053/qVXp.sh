#!/bin/bash
$timer=5000
#Mostra il numero di CPU logiche e fisiche all'inizio
echo "Informazioni CPU:"
lscpu | grep -E '^CPU\(s\) : | ^Socket\(s\s):'

#Messaggio iniziale
echo ""
echo "Monitoraggio in tempo reale (Aggiornato ogni 5 secondi). Premere CTR + C per uscire."

#Loop per aggiornare le informazioni ogni 5 secondi
while true; do
    #pulire lo schermo
    clear 

    #Mostra il numero di CPU logiche e fisiche
    echo "Informazioni CPU:"
    lscpu | grep -E '^CPU\(s\) : | ^Socket\(s\s):'
    echo "------------------------------------------"

    #Utilizzo delle CPU
    echo "Utilizzo delle CPU"
    mpstat -P ALL 1 1

    #Utilizzo della RAM
    echo ""
    echo "Utilizzo della RAM"
    free -h

    #Carico medio del sistema
    echo ""
    echo "Carico medio del sistema: "
    uptime 

    sleep 5
done