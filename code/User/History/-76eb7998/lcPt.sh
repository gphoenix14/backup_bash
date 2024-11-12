#|/bin/bash

#Ciclo While

contatore=1

while [ $contatore -le 5 ]; do 
    echo "Contatore: $contatore"
    ((contatore++))
done
