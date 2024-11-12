#!/bin/bash

#Stampa se un numero è maggiore di controllo
numero=10
controllo=5

if [ $numero -gt $controllo ]; then
	echo "il numero $numero è maggiore di $controllo"
elif [ $numero -eq $controllo ]; then
	echo "il numero $numero è uguale a $controllo"
else
	echo "il numero $numero è minore di $controllo"
fi



