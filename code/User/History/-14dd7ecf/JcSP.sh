#!/bin/bash

mostra_menu(){
    echo "1) Saluta"
    echo "2) Esci" 
}

saluta(){
    echo "Inserisci il tuo nome:"
    read nome
    echo "Ciao, $nome!"
}

while true; do
    mostra_menu
    read -p "scegli un'opzione: " scelta

    case $scelta in 
        1) saluta ;;
        2) echo "Uscita..."; exit 0 ;;
        *) echo "Opzione non valida." ;;
    esac
done
