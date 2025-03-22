#!/bin/bash

# Crea la directory per gli ambienti virtuali
mkdir -p /usr/local/venvs

# Crea l'ambiente virtuale Python
python -m venv /usr/local/venvs/myenv

# Attiva l'ambiente virtuale
source /usr/local/venvs/myenv/bin/activate

# Upgrade di pip all'ultima versione
echo "Aggiornamento di pip all'ultima versione..."
/usr/local/venvs/myenv/bin/python -m pip install --upgrade pip

# Cerca il file requirements.txt in tutta la struttura del workspace
echo "Cercando il file requirements.txt..."
REQUIREMENTS_FILES=$(find /workspaces -maxdepth 3 -name "requirements.txt" -type f)

if [ -n "$REQUIREMENTS_FILES" ]; then
  # Prendi il primo file requirements.txt trovato
  REQUIREMENTS_FILE=$(echo "$REQUIREMENTS_FILES" | head -n 1)
  echo "Trovato requirements.txt in: $REQUIREMENTS_FILE"
  echo "Installazione pacchetti..."
  /usr/local/venvs/myenv/bin/python -m pip install -r "$REQUIREMENTS_FILE"
  echo "Installazione completata!"
else
  echo "Attenzione: Nessun file requirements.txt trovato nelle directory del workspace."
  echo "L'ambiente virtuale è stato creato ma nessun pacchetto è stato installato."
fi

# Informa l'utente sul completamento dello script
echo "Setup dell'ambiente virtuale Python 3.11 completato."
echo "L'ambiente virtuale è disponibile in: /usr/local/venvs/myenv"