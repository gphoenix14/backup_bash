#!/bin/bash

#Verifica se è stata passata un'interfaccia di rete come argomento
if [ -z "$1" ]; then 
    echo "Utilizzo : $0 <interfaccia di rete>"
    echo "Esempio: $0 eth0"
    exit 1
fi

