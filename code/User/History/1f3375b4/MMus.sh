#!/bin/bash

# Leggi il file di configurazione
config_file="backup.conf"

# Verifica se il file di configurazione esiste
if [[ ! -f "$config_file" ]]; then
    echo "Errore: Il file di configurazione $config_file non esiste."
    exit 1
fi

# Estrai i valori dal file di configurazione
source_dirs=$(grep -E '^source=' "$config_file" | cut -d'=' -f2 | tr -d '"')
dest_folder=$(grep -E '^dest_folder=' "$config_file" | cut -d'=' -f2 | tr -d '"')
useTAR=$(grep -E '^useTAR=' "$config_file" | cut -d'=' -f2 | tr -d '"')
useXZ=$(grep -E '^useXZ=' "$config_file" | cut -d'=' -f2 | tr -d '"')
useGZIP=$(grep -E '^useGZIP=' "$config_file" | cut -d'=' -f2 | tr -d '"')

# Ottieni la data e crea la cartella di destinazione
datetime=$(date +"%Y%m%d_%H%M%S")
backup_dir="$dest_folder/backup_$datetime"
mkdir -p "$backup_dir"

# Chiedi all'utente il tipo di backup
read -p "Scegli il tipo di backup (full/differential): " backup_type

# Funzione per il backup completo
backup_full() {
    for dir in ${source_dirs//,/ }; do
        echo "Eseguo il backup completo della directory: $dir"
        cp -ar "$dir" "$backup_dir"
    done
}

# Funzione per il backup differenziale
backup_differential() {
    for dir in ${source_dirs//,/ }; do
        echo "Eseguo il backup differenziale della directory: $dir"
        rsync -a --delete "$dir/" "$backup_dir/$(basename "$dir")"
    done
}

# Esegui il backup in base alla scelta dell'utente
if [[ "$backup_type" == "full" ]]; then
    backup_full
elif [[ "$backup_type" == "differential" ]]; then
    backup_differential
else
    echo "Tipo di backup non valido. Uscita."
    exit 1
fi

# Creazione dell'archivio se richiesto
archive_name="backup_$datetime"

if [[ "$useTAR" == "true" ]]; then
    echo "Creazione dell'archivio TAR..."
    tar -cf "$backup_dir/$archive_name.tar" -C "$backup_dir" .
    if [[ "$useXZ" == "true" ]]; then
        echo "Compressione con XZ..."
        xz "$backup_dir/$archive_name.tar"
    elif [[ "$useGZIP" == "true" ]]; then
        echo "Compressione con GZIP..."
        gzip "$backup_dir/$archive_name.tar"
    fi
else
    echo "Copia dei file senza creare un archivio TAR."
fi

echo "Backup completato con successo in: $backup_dir"
