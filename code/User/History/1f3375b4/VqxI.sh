#!/bin/bash

backup_full() {
    if [[ "$userTAR" == "true"]]; then  
        echo "Creazione dell'archivio TAR completo..."
        tar -cf "$archive_path.tar" ${source_dirs//,/}
    else
        echo "Creazione della cartella di backup: $backup_dir"
        mkdir -p "$backup_dir"
        for dir in $(source_dirs//,/); do
            echo "Copia della directory $dir in $backup_dir"
            cp -ar "$dir" "$backup_dir/"
        done
    fi
}

backup_differential() {
    if [["$userTAR" == "true"]]; then
        echo "Creazione dell'archivio TAR completo..."
        tar -cf "$archive_path.tar" ${source_dirs//,/}
    else
        echo "Creazione della cartella di backup: $backup_dir"
        mkdir -p "$backup_dir"
        for dir in $(source_dirs//,/); do
            echo "Eseguo il backup differenziale della directory $dir in $backup_dir"
            rsync -a --delete "$dir/" "$backup_dir/$(basename "$dir")"
        done
    fi

}

config_file="backup.conf"

#Verifica se il file esiste
if [[ ! -f "config_file" ]]; then
    echo "Errore: il file di configurazione $config_file non esiste."
    exit 1
fi

#Estraiamo i valori dal file di configurazione
source_dirs=$(grep -E '^source=' "$config_file" | cut -d'=' -f2 | tr -d '"')
dest_folder=$(grep -E '^dest_folder=' "$config_file" | cut -d'=' -f2 | tr -d '"')
userTAR=$(grep -E '^useTAR=' "$config_file" | cut -d'=' -f2 | tr -d '"')
useXZ=$(grep -E '^useXZ=' "$config_file" | cut -d'=' -f2 | tr -d '"')
useGZIP=$(grep -E '^useGZIP=' "$config_file" | cut -d'=' -f2 | tr -d '"')

#Ottieniamo la data per il nome dell'archivio/cartella
datetime=$(date + "%Ym%d_%H%M%S")
backup_dir = "$dest_folder/backup_$datetime"
archive_path= "$dest_folder/backup_$datetime"

#chiediamo all'utente il tipo di backup che vuole fare

read -p "Scegli il tipo di backup (full/differential): "backup_type



