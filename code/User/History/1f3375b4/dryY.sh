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

# Ottieni la data per il nome dell'archivio
datetime=$(date +"%Y%m%d_%H%M%S")
archive_name="backup_$datetime"
archive_path="$dest_folder/$archive_name"

# Chiedi all'utente il tipo di backup
read -p "Scegli il tipo di backup (full/differential): " backup_type

# Funzione per il backup completo
backup_full() {
    if [[ "$useTAR" == "true" ]]; then
        echo "Creazione dell'archivio TAR completo..."
        tar -cf "$archive_path.tar" ${source_dirs//,/ }
    else
        echo "Eseguo il backup completo senza archiviazione TAR..."
        for dir in ${source_dirs//,/ }; do
            cp -ar "$dir" "$dest_folder"
        done
    fi
}

# Funzione per il backup differenziale
backup_differential() {
    if [[ "$useTAR" == "true" ]]; then
        echo "Creazione dell'archivio TAR differenziale..."
        tar -cf "$archive_path.tar" ${source_dirs//,/ } --newer-mtime="$(date -d '1 day ago' +%Y-%m-%d)"
    else
        echo "Eseguo il backup differenziale senza archiviazione TAR..."
        for dir in ${source_dirs//,/ }; do
            rsync -a --delete "$dir/" "$dest_folder/$(basename "$dir")"
        done
    fi
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

# Applica la compressione se richiesto
if [[ "$useTAR" == "true" ]]; then
    if [[ "$useXZ" == "true" ]]; then
        echo "Compressione con XZ..."
        xz "$archive_path.tar"
    elif [[ "$useGZIP" == "true" ]]; then
        echo "Compressione con GZIP..."
        gzip "$archive_path.tar"
    fi
    echo "Archivio creato: $archive_path.tar${useXZ:+.xz}${useGZIP:+.gz}"
else
    echo "Backup completato senza archivio TAR."
fi

echo "Backup completato con successo."
