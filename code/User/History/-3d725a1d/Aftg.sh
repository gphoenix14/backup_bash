#!/bin/bash

# Caricare il file di configurazione
source "backup.conf"

# Timestamp per il backup
TIMESTAMP=$(date +%Y%m%d)

# Controllo delle cartelle di destinazione
mkdir -p "$dest_folder_full"
mkdir -p "$dest_folder_differential"

# Verifica se la cartella sorgente esiste
if [[ ! -d "$source" ]]; then
    echo "Errore: La cartella sorgente non esiste."
    exit 1
fi

# Chiedere il tipo di backup
read -p "Vuoi fare un backup completo o differenziale? (completo/differenziale): " BACKUP_TYPE

# Backup completo
if [[ "$BACKUP_TYPE" == "completo" ]]; then
    BACKUP_NAME="backup_full_${TIMESTAMP}"
    BACKUP_PATH="${dest_folder_full}/${BACKUP_NAME}"

    echo "Esecuzione del backup completo..."
    rsync -av --progress "$source/" "$BACKUP_PATH/"

# Backup differenziale
elif [[ "$BACKUP_TYPE" == "differenziale" ]]; then
    BACKUP_NAME="backup_diff_${TIMESTAMP}"
    BACKUP_PATH="${dest_folder_differential}/${BACKUP_NAME}"

    # Ultimo backup completo
    LAST_FULL_BACKUP=$(ls -td "${dest_folder_full}/backup_full_"* | head -n 1)

    if [[ -z "$LAST_FULL_BACKUP" ]]; then
        echo "Errore: Nessun backup completo trovato per il confronto."
        exit 1
    fi

    echo "Esecuzione del backup differenziale confrontando con $LAST_FULL_BACKUP..."
    rsync -av --progress --link-dest="$LAST_FULL_BACKUP" "$source/" "$BACKUP_PATH/"

else
    echo "Errore: Scelta del backup non valida."
    exit 1
fi

# Messaggio di completamento
echo "Backup completato: ${BACKUP_PATH}"
