#!/bin/bash

nome="Pippo"

saluta() {
    local nome="Dragoniere"
    echo "Ciao sono $nome e saluto  $1 e $2"
}

saluta "Giuseppe" "Giacomo"
echo "sono $nome"
