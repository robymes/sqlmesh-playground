# SQLMesh Playground
Questo repo fornisce un ambiente di sviluppo di prova per SQLMesh che sfrutta VisualStudio Code e la possibilità di lavorare all'intero di un container Docker pre-configurato.

## Prerequisiti
Prima di iniziare, assicurati di avere installato i seguenti software:

1. [Visual Studio Code](https://code.visualstudio.com/)
2. [Rancher Desktop](https://rancherdesktop.io/) (come engine Docker locale)

## Passaggi per il Setup dell'ambiente di sviluppo

1. **Installa l'Estensione Dev Containers in VS Code**
   - Apri Visual Studio Code
   - Vai alla sezione delle estensioni (Ctrl+Shift+X)
   - Cerca "Remote - Containers"
   - Installa l'estensione fornita da Microsoft

2. **Configura Rancher Desktop**
   - Apri Rancher Desktop
   - Nelle impostazioni, assicurati che sia selezionato "dockerd (moby)" come engine

3. **Clona e Apri il Repository nel Dev Container**
   - In VS Code, premi F1 (o Ctrl+Shift+P) per aprire la palette dei comandi
   - Digita "Dev Containers: Clone Repository in Container Volume" e seleziona il comando
   - Inserisci l'URL del repository GitHub: https://github.com/robymes/sqlmesh-playground.git
   - Selezionare la branch di riferimento: **main**
   - Seleziona la cartella di destinazione per il clone locale
   - VS Code clonerà il repository e aprirà il progetto in un container

4. **Attendi il Completamento del Build**
   VS Code clonerà il repository, costruirà e avvierà il container, e si connetterà automaticamete allo stesso puntando direttamente al suo file system.  
   Questo processo potrebbe richiedere alcuni minuti la prima volta, per monitorare l'avanzamento del processo aprire la finestra di Output dalla notifica che viene presentata da VS Code (o tramite Ctrl+Shift+U)

5. **Accedi all'ambiente**
   Una volta completato il processo, sarai all'interno dell'ambiente di sviluppo containerizzato. L'ambiente è già configurato con Python e SQLMesh, oltre a tutte le estensioni di VS Code che possono essere utili nell'esplorazione del progetto.  
   Inoltre vengono avviati altri due container per le due istanze di PostgreSQL su cui insistono il database di stato di SQLMesh e il DWH di lavoro.

### Risoluzione dei Problemi
- Se incontri problemi con la build del container, verifica che Rancher Desktop sia in esecuzione e configurato correttamente.
- Assicurati di avere l'ultima versione di VS Code e dell'estensione Remote - Containers.
- Controlla i log di VS Code per eventuali errori specifici.
- Se il clone del repository fallisce, assicurati di avere le corrette credenziali di accesso per GitHub configurate in VS Code.

### Note Aggiuntive
- Il file `.devcontainer/devcontainer.json` nel repository contiene la configurazione del Dev Container. Puoi modificarlo per personalizzare ulteriormente l'ambiente.
- Per ulteriori informazioni su come utilizzare Dev Containers, consulta la [documentazione ufficiale di VS Code](https://code.visualstudio.com/docs/remote/containers).
- Se desideri aprire un repository esistente in un container, puoi utilizzare il comando "Remote-Containers: Open Folder in Container" dalla palette dei comandi.

## Esplorare e lavorare con l'ambiente di sviluppo

> **IMPORTANTE**  
Nel caso si volessero apportare delle modifiche al progetto è **mandatorio** creare una nuova branch Git per non lavorare direttamente nella **main**.

### Documentazione SQLMesh 
Trovate tutta le informazioni e la documentazione di SQLMesh qui:
- https://sqlmesh.com/
- https://sqlmesh.readthedocs.io/en/stable/

Per chi conoscesse DBT è consigliata la lettura di questi articoli:
- https://www.harness.io/blog/from-dbt-to-sqlmesh
- https://kestra.io/blogs/2024-02-28-dbt-or-sqlmesh

### Attivare la CLI dell'ambiente di sviluppo
Sono necessarie un paio di azioni prima di lavorare nell'ambiente di sviluppo:
- L'ambiente di sviluppo è già configurato con un environment locale di Python, è necessario attivarlo prima di usare la riga di comando
  - Aprire la finestra del Terminal (Ctrl+ò)
  - Eseguire il comando `source .env/bin/activate`
  - Eseguire il comando `sqlmesh UI` per attivare la [web interface di SQLMesh](https://sqlmesh.readthedocs.io/en/stable/guides/ui/) (di default raggiungibile all'indirizzo http://localhost:8000)

### Struttura del progetto
Il progetto rappresenta un semplice e basilare esempio di utilizzo di SQLMesh:
- Legge parzialmente il contenuto di una tabella da una fonte dati esterna: sono i dati pubblici delle corse dei taxi di New York disponibili liberamente in una istanza demo di Motherduck (https://motherduck.com/)
- Applica un paio di trasformazioni ai dati sorgente utilizzando i modelli di SQLMesh

#### Container Docker
Il progetto VS Code inizalizza ed esegue tre diversi container Docker (trovate tutte le specifiche nella cartella `.devcontainer`):
- **Devcontainer**: è un container Linux che contiene fisicamente il codice del progetto e le librerie necessarie ed a cui si connette VS Code
- **PostgreSQL #1**: contiene l'istanza del database di stato di SQLMesh
- **PostgreSQL #2**: contiene l'istanza del database che rappresenta il DWH operativo della demo

#### Filesystem
La struttura del filesystem del progetto è quella standard suggerita dalla documentazione di SQLMesh, al fine di sperimentare la tecnologia si consiglia di lavorare solo nelle cartelle `models`, `tests`, `audits`.  
Nelle cartelle `models` e `audits` sono già presenti i file di base che rappresentano la demo:
- `models/taxi_external.py`: [model di tipo Python](https://sqlmesh.readthedocs.io/en/stable/concepts/models/python_models/) usato come esempio sia per quanto riguarda l'uso di Python che per quanto riguarda l'uso di [model di tipo EXTERNAL](https://sqlmesh.readthedocs.io/en/stable/concepts/models/external_models/)
- `models/taxi_bronze.sql`: [model di tipo SQL](https://sqlmesh.readthedocs.io/en/stable/concepts/models/sql_models/) e [INCREMENTAL_BY_TIME_RANGE](https://sqlmesh.readthedocs.io/en/stable/concepts/models/model_kinds/#incremental_by_time_range), usato come primo step di gestione del dato grezzo in cui si selezionano solo alcune colonne senza ulteriori elaborazioni 
- `models/taxi_kpi_gold.sql`: [model di tipo SQL](https://sqlmesh.readthedocs.io/en/stable/concepts/models/sql_models/) e [FULL](https://sqlmesh.readthedocs.io/en/stable/concepts/models/model_kinds/#full), usato per applicare alcune trasformazioni al dato al fine di calcolare alcune aggregazioni
- `test/test_taxi_bronze.yaml`: [test](https://sqlmesh.readthedocs.io/en/stable/concepts/tests/) applicato al model `taxi_bronze.sql`, per verificare che la configurazione del time range prenda in considerazione solo i record che presentano il corretto valore di timestamp
- `audits/assert_taxi_passengers_not_null.sql`: [audit](https://sqlmesh.readthedocs.io/en/stable/concepts/audits/) applicato al model `taxi_kpi_gold.sql`, per verificare che uno dei campi di aggregazione non sia NULL

### Esecuzione di SQLMesh
La prima volta che viene lanciato il progetto i database sono vuoti, è necessario eseguire SQLMesh per la prima alimentazione del DWH.  
Da quel momento in poi, se i container non vengono cancellati, bensì solo interrotti, il dato rimane persistito anche per i successivi riavvi del devcontainer.

Sono disponibili due modalità di lavoro:
- Lavorare direttamente nella web UI di SQLMesh
- Lavorare da CLI in VS Code

Si suggerisce di provarle entrambe per familiarizzare con entrambe le modalità.

Per eseguire la prima alimentazione del DWH è necessario eseguire il comando [`sqlmesh plan`](https://sqlmesh.readthedocs.io/en/stable/concepts/plans/), la prima volta ci impiegherà qualche minuto perchè deve scaricare qualche migliaio di record dalla tabella esterna di Motherduck nel cloud.