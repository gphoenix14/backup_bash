#!/bin/bash

# Cartella di destinazione del backup
DEST_DIR="$PWD/backup"
TIMESTAMP=$(date +%Y%m%d)

# Chiedere all'utente il percorso della cartella sorgente
read -p "Inserisci il percorso della cartella da cui fare il backup: " SOURCE_DIR

# Controllare se la cartella sorgente esiste
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Errore: La cartella sorgente non esiste."
    exit 1
fi

# Chiedere il tipo di backup
read -p "Vuoi fare un backup completo o differenziale? (completo/differenziale): " BACKUP_TYPE

# Chiedere se comprimere il backup
read -p "Vuoi comprimere i file? (si/no): " COMPRESS

# Creare la cartella di destinazione se non esiste
mkdir -p "$DEST_DIR"

# Eseguire il backup completo con 'cp'
if [[ "$BACKUP_TYPE" == "completo" ]]; then
    BACKUP_NAME="backup_full_${TIMESTAMP}"
    BACKUP_PATH="${DEST_DIR}/${BACKUP_NAME}"

    echo "Esecuzione del backup completo..."
    cp -r "$SOURCE_DIR" "$BACKUP_PATH"

# Eseguire il backup differenziale con 'rsync'
elif [[ "$BACKUP_TYPE" == "differenziale" ]]; then
    BACKUP_NAME="backup_diff_${TIMESTAMP}"
    BACKUP_PATH="${DEST_DIR}/${BACKUP_NAME}"

    echo "Esecuzione del backup differenziale con rsync..."
    rsync -av --progress "$SOURCE_DIR/" "$BACKUP_PATH/"

else
    echo "Errore: Scelta del backup non valida."
    exit 1
fi

# Comprimere il backup se richiesto
if [[ "$COMPRESS" == "si" ]]; then
    echo "Compressione del backup in corso..."
    tar -czvf "${BACKUP_PATH}.tar.gz" -C "$DEST_DIR" "$BACKUP_NAME"
    rm -rf "$BACKUP_PATH"
    BACKUP_PATH="${BACKUP_PATH}.tar.gz"
fi

# Messaggio di completamento
echo "Backup completato: ${BACKUP_PATH}"
