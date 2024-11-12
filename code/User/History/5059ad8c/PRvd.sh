#!/bin/bash

nome="Mario" #dichiarazione variabile
readonly costante=10 #dichiarazione costante
declare -r costante2=30 #altro modo per dichiarare una costante
echo "Ciao, $nome !"
echo 'Ciao, $nome'
echo "questa è una costante $costante"
nome="Giuseppe"
costante=20 #questo genererà un errore in fase di runtime
    echo "questa è una costante $costante"
    echo "Ciao, $nome !"


