#!/bin/bash

nome="Pippo"

saluta() {
    local nome="Dragoniere"
    echo "Ciao sono $nome , $1 e $2"
}

saluta "Giuseppe" "Giacomo"
