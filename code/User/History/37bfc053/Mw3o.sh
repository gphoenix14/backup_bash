#!/bin/bash

#Mostra il numero di CPU logiche e fisiche all'inizio
echo "Informazioni CPU:"
lscpu | grep -E '^CPU\(s\) : | ^Socket\(s\s):'