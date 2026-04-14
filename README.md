# Password Manager

Un gestore di password KeePass-compatibile per Android, costruito con Flutter.  
Gestisce credenziali in file **KDBX** (lo stesso formato di KeePass 2.x), con crittografia
AES-256/Argon2, sblocco biometrico, OTP/2FA, allegati e sincronizzazione cloud.

---

## Indice

1. [Funzionalità](#funzionalità)
2. [Requisiti](#requisiti)
3. [Build](#build)
4. [Schermate in dettaglio](#schermate-in-dettaglio)
5. [Impostazioni di sicurezza](#impostazioni-di-sicurezza)
6. [Import / Export](#import--export)
7. [Struttura del progetto](#struttura-del-progetto)
8. [Dipendenze principali](#dipendenze-principali)

---

## Funzionalità

| Area | Funzionalità |
|------|-------------|
| **Database** | Crea / apri / salva file KDBX 3.x/4.x; compatibile con KeePass 2.x, Strongbox, Bitwarden KeePass |
| **Voci** | Titolo, username, password, URL, note, campi personalizzati (anche protetti), allegati binari, tag, cronologia |
| **Gruppi** | Albero gerarchico con creazione, rinomina, eliminazione, spostamento |
| **2FA / TOTP** | Aggiunta URI `otpauth://`, generazione codice con countdown animato (SHA-1/256/512) |
| **Generatore** | Password casuali (4–64 char, charset selezionabile, caratteri esclusi) e passphrase (3–8 parole italiane) |
| **Ricerca** | Full-text sui campi principali + custom fields, filtro per gruppo, highlight inline dei match |
| **Biometria** | Sblocco con impronta digitale o Face Unlock; password salvata in AES-256 secure storage |
| **Auto-lock** | Timeout configurabile (30 s → 30 min → Mai); blocco su pausa app; auto-exit opzionale |
| **Tema** | Chiaro / Scuro / Sistema; Material Design 3 |
| **Lingua** | Italiano, Inglese (selezionabile a runtime; struttura pronta per FR, DE, ES, ZH, RU, AR) |
| **Autofill** | Servizio Android Autofill Framework per compilare campi app/browser |
| **Intent .kdbx** | Apri file KDBX direttamente dal file manager, e-mail, ecc. |
| **Export** | KDBX (nativo), CSV, PDF (singola voce o intero vault) |
| **Import** | CSV; JSON legacy (compatibilità versione Kotlin precedente) |
| **Cloud sync** | Google Drive, WebDAV — stub implementato, wiring in sviluppo |
| **Sicurezza UI** | Blocco screenshot (`FLAG_SECURE`), wakelock, pulizia clipboard automatica |

---

## Requisiti

- **Flutter SDK** ≥ 3.11 (testato su Flutter 3.41 / Dart 3.11)
- **Android SDK** 29+ (Android 10, minSdk 29 — obbligatorio per `flutter_autofill_service`)
- **JDK** 17 (impostato in `android/build.gradle.kts`)
- **NDK** gestito automaticamente da Flutter Gradle Plugin

---

## Build

### Dipendenze

```bash
flutter pub get
```

### APK Debug (installazione rapida, non firmato)

```bash
flutter build apk --debug
```

### APK Release (firmato, ottimizzato, ~74 MB fat APK)

```bash
flutter build apk --release
```

L'APK generato si trova in:

```
build/app/outputs/flutter-apk/app-release.apk   # release
build/app/outputs/flutter-apk/app-debug.apk     # debug
```

Per copiarlo nella cartella `dist` del progetto:

```bash
# PowerShell
New-Item -ItemType Directory -Force -Path dist
Copy-Item build\app\outputs\flutter-apk\app-release.apk dist\password-manager-release.apk
```

### APK per architettura singola (file più piccolo)

```bash
flutter build apk --release --target-platform android-arm64
```

### App Bundle (per Google Play)

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### Nota per build su Windows con progetto su drive diverso dal Pub Cache

Se il progetto si trova su un drive diverso da quello predefinito (es. `E:\` vs `C:\`),
KSP/Kotlin fallisce con un errore `toRelativeString`. Soluzione:

```powershell
# Imposta la cache Flutter sullo stesso drive del progetto
$env:PUB_CACHE = 'E:\Progetti\ai\.pub-cache'

# Pulisci le cache di build precedenti
Remove-Item -Recurse -Force .dart_tool, build -ErrorAction SilentlyContinue

# Ricompila
flutter pub get
flutter build apk --release
```

Assicurarsi anche che `android/gradle.properties` contenga:

```properties
kotlin.incremental=false
ksp.incremental=false
org.gradle.parallel=false
```

### Firma Release

Il keystore è in `android/release.jks`; le credenziali sono lette da `android/key.properties`:

```properties
keyAlias=release-key
keyPassword=<password>
storeFile=release.jks
storePassword=<password>
```

`key.properties` è escluso da `.gitignore`. Senza di esso la build release non viene firmata.

---

## Schermate in dettaglio

### Onboarding (primo avvio)

Wizard a 5 pagine mostrato alla prima installazione:

1. **Benvenuto** — presentazione dell'app.
2. **Master Password** — spiega il concetto di password principale e l'importanza di non perderla.
3. **Crea database** — inserimento del nome database (default: `Passwords`), master password con conferma e indicatore forza in tempo reale (lunghezza minima, corrispondenza, valutazione entropia).
4. **Biometria** — opzionale; se il dispositivo la supporta, permette di abilitarla subito. Salva la master password in `FlutterSecureStorage`  (AES-256) per sblocchi rapidi successivi.
5. **Completamento** — pulsante _"Vai al vault"_ che apre direttamente la home.

Al termine, il wizard crea un file KDBX con **6 gruppi predefiniti**: Generale, Email, Social, Banca, Carte di credito, Nota sicure.

---

### Vault Selector

Punto di accesso ai database, mostrato quando non c'è un file recente disponibile:

- **Crea nuovo database** — dialog con nome e master password; crea il file `.kdbx` nella directory documenti dell'app.
- **Apri database esistente** — FilePicker per selezionare qualsiasi file `.kdbx` sul dispositivo; chiede la master password.
- **Database recenti** — lista con path, indicatore di disponibilità (grigio se il file è stato spostato/eliminato), pulsante × per rimuovere dalla lista.

---

### Sblocco (Unlock)

Presentata all'avvio se esiste già un database e dopo ogni auto-lock:

- Tenta lo **sblocco biometrico automatico** se abilitato e se il file è già stato aperto in precedenza.
- Campo **Master Password** con toggle visibilità e pulsante _"Sblocca"_ (disabilitato durante il caricamento).
- Pulsante fingerprint per ritentare la biometria manualmente.
- Verifica il timeout di auto-lock prima di aprire; se scaduto e auto-exit è attivo, chiude l'app.

---

### Home — Lista Voci

Schermata principale dell'app:

**AppBar**
- Titolo dinamico con il nome del gruppo attivo (o _"Tutte le voci"_).
- Icona 🔍 → Ricerca globale.
- Menu ordinamento: per titolo (A-Z), per data modifica, per data creazione.
- Icona ⚙️ → Impostazioni.

**Drawer laterale**

| Sezione | Contenuto |
|---------|-----------|
| Visualizzazione | _Tutte le voci_ / _Voci archiviate_ (con contatore) |
| Tag | Chip filtro orizzontali per ogni tag presente nel vault |
| Gruppi | Albero navigabile; pulsante + per creare un nuovo gruppo |
| Info database | Nome file, numero voci, numero gruppi |
| Import / Export | KDBX, CSV, PDF, JSON legacy, importa CSV |
| Utility | Generatore password, About, Blocca |

**Lista voci**
- Card con avatar (iniziale del titolo), titolo, username, nome gruppo.
- Tap → Dettaglio voce.
- FAB **+** per aggiungere una nuova voce nel gruppo selezionato.

**Comportamento ciclo di vita**
- Quando l'app va in background, avvia il countdown per il timeout auto-lock.
- Al ritorno in foreground, se il timeout è scaduto: reindirizza a Unlock o chiude l'app (dipende da _Auto-Exit_).
- Prima di bloccare, salva automaticamente il database.
- Se _Stai sveglio_ è attivo, mantiene il wakelock durante tutto il ciclo di vita.

---

### Dettaglio Voce

Visualizzazione completa di un credential:

- **Campi standard** — Username, password (nascosta, con toggle), URL, note; tutti copiabili con un tap; toast di conferma + pulizia clipboard automatica dopo il delay configurato.
- **TOTP / 2FA** — codice a 6 cifre con separatore centrale (`123 456`), barra/contatore circolare da 30 s, rosso negli ultimi 5 s. Supporta SHA-1, SHA-256, SHA-512.
- **Tag** — chip visualizzati inline.
- **Campi personalizzati** — mostrati con icona dedicata; i campi protetti rimangono oscurati.
- **Allegati** — nome file e pulsante di download.
- **Timestamp** — data/ora di creazione e ultima modifica.

**Azioni menu (⋮)**

| Azione | Comportamento |
|--------|--------------|
| Modifica | → Entry Form Screen |
| Archivia / Ripristina | Nasconde/mostra la voce dalla vista principale |
| Esporta PDF | PDF della singola voce |
| Stampa | Dialog stampa nativa Android |
| Cronologia | Bottom sheet con tutte le versioni storiche KDBX |
| Elimina | Dialog di conferma, poi cancellazione permanente |

---

### Modifica / Crea Voce (Entry Form)

Form con validazione inline:

| Campo | Note |
|-------|------|
| Titolo | Obbligatorio |
| Username | Facoltativo |
| Password | Toggle visibilità; pulsante ⚡ per generazione automatica (20 char, tutti i charset); barra di forza colorata |
| URL | Keyboard type `url` |
| Note | Multiline |
| TOTP | URI `otpauth://totp/…`; collassabile |
| Tag | Chip rimovibili + input per aggiungere; collassabile |
| Campi personalizzati | Nome + valore + toggle protezione + rimozione; collassabile |
| Allegati | FilePicker (solo in modifica); collassabile |

Al salvataggio:
- Se **creazione**: aggiunge la voce al gruppo, torna alla home.
- Se **modifica**: aggiorna la voce, torna al dettaglio.
- Salva il database su disco in entrambi i casi.

---

### Ricerca Globale

- Campo di testo con autofocus, refresh in tempo reale.
- Cerca in: titolo, username, URL, note, campi personalizzati.
- Evidenzia le corrispondenze con background colorato (highlight inline).
- Filtro per gruppo tramite popup menu (icona filtro colorata se attivo).
- Stati: _"Cerca tra le voci"_ (prima della digitazione), _"Nessun risultato"_ (query senza match).
- Tap su risultato → Dettaglio voce; icona copia a destra → copia password direttamente.

---

### Generatore Password

Accessibile dal drawer, dalla schermata di creazione voce e dalle Impostazioni.

**Modalità Caratteri Casuali**

| Parametro | Dettaglio |
|-----------|-----------|
| Lunghezza | Slider 4–64, default 20 |
| Maiuscole A-Z | Toggle |
| Minuscole a-z | Toggle |
| Numeri 0-9 | Toggle |
| Simboli `!@#$%^&*` | Toggle |
| Escludi caratteri | Campo libero, utile per escludere caratteri ambigui (`0OlI1`) |

**Modalità Passphrase**

| Parametro | Dettaglio |
|-----------|-----------|
| Numero parole | Slider 3–8, default 4 |
| Separatore | Campo libero, default `-` |

Parole da dizionario italiano (animali, oggetti, colori, concetti — 100+ lemmi).

**Valutazione forza** — scala 0–4 (Molto debole → Molto forte) basata su lunghezza, varietà charset ed entropia teorica; barra colorata con etichetta testuale.

Rigenera automaticamente ad ogni modifica di parametro. Usa `Random.secure()` (CSPRNG).

---

## Impostazioni di sicurezza

### Biometria

- Toggle per abilitare/disabilitare.
- All'abilitazione: richiede verifica biometrica + inserimento master password per salvare nel secure storage.
- Alla disabilitazione: cancella la password salvata.

### Auto-lock timeout

Opzioni disponibili: Immediatamente, 30 s, 1 min, 5 min, 15 min, 30 min, Mai.

### Pulizia clipboard

Opzioni: 15 s, 30 s, 1 min, 2 min, Mai.  
Si attiva dopo ogni copia di password o codice TOTP.

### Cambia master password

Dialog a tre campi (password attuale con verifica, nuova password, conferma).  
Mostra barra di forza sulla nuova password; richiede almeno forza _"Discreta"_.

### Altre opzioni di sicurezza

| Impostazione | Default | Comportamento |
|---|---|---|
| Stai sveglio | Off | Mantiene schermo acceso tramite wakelock |
| Permetti screenshot | Off | Abilita/disabilita `FLAG_SECURE` su tutte le finestre |
| Auto-exit | Off | Chiude l'app al timeout invece di mostrare solo Unlock |

### Tema

Radio button: Sistema / Chiaro / Scuro.

### Lingua

Dialog con selezione locale a runtime: Italiano 🇮🇹, English 🇬🇧, e altre lingue supportate.

---

## Import / Export

| Operazione | Formato | Note |
|---|---|---|
| Esporta database | `.kdbx` | Copia il file corrente nella destinazione scelta |
| Esporta CSV | `.csv` | Tutte le voci in chiaro — conservare con cura |
| Esporta PDF | `.pdf` | Singola voce o intero vault; include tutti i campi (password oscurate) |
| Importa CSV | `.csv` | Mapping colonne automatico; mostra conteggio voci importate |
| Importa da vecchia app | `.json` | Compatibilità con versione precedente Kotlin |

---

## Struttura del progetto

```
lib/
├── main.dart                              # Entry point, inizializzazione Riverpod
├── app.dart                               # MaterialApp.router con GoRouter
├── theme/app_theme.dart                   # Palette Material 3, tema chiaro/scuro
├── l10n/                                  # File ARB e classi AppLocalizations generate
├── core/
│   ├── router.dart                        # Definizione route GoRouter
│   ├── kdbx/kdbx_service.dart             # Tutte le operazioni KDBX (open/save/CRUD entry)
│   ├── storage/file_source.dart           # Astrazione lettura/scrittura file (locale + cloud)
│   ├── auth/
│   │   ├── auth_service.dart              # Biometria + FlutterSecureStorage
│   │   └── auto_lock_manager.dart         # Timeout auto-lock, LockStateNotifier
│   ├── crypto/password_generator.dart     # Generazione password/passphrase, calcolo forza
│   ├── csv/                               # Parser/writer CSV
│   ├── pdf/                               # Generazione documenti PDF
│   └── providers/settings_provider.dart  # Tutti i provider Riverpod (tema, timeout, ecc.)
└── features/
    ├── onboarding/onboarding_screen.dart  # Wizard primo avvio
    ├── unlock/unlock_screen.dart          # Sblocco con password o biometria
    ├── vault/vault_selector_screen.dart   # Selezione / creazione database
    ├── home/home_screen.dart              # Lista voci + drawer gruppi
    ├── entries/
    │   ├── entry_detail_screen.dart       # Visualizzazione voce, TOTP, allegati
    │   └── entry_form_screen.dart         # Creazione / modifica voce
    ├── groups/                            # Gestione gruppi (crea, rinomina, elimina, sposta)
    ├── search/search_screen.dart          # Ricerca full-text con highlight
    ├── settings/settings_screen.dart      # Tutte le impostazioni
    └── password_gen/                      # Generatore password standalone
```

---

## Dipendenze principali

| Categoria | Libreria | Versione | Uso |
|-----------|----------|---------|-----|
| Database | `kdbx` | 2.4.2 | Lettura/scrittura file KeePass KDBX |
| Crittografia | `argon2_ffi_base` | 1.1.1 | Key derivation Argon2 |
| Crittografia | `pointycastle` | 3.9.1 | Primitive AES, SHA |
| State | `flutter_riverpod` | 2.6.1 | Gestione stato reattivo |
| Navigazione | `go_router` | 14.8.1 | Routing dichiarativo |
| Storage | `flutter_secure_storage` | 9.2.4 | Keystore AES-256 per master password |
| Storage | `shared_preferences` | 2.5.3 | Preferenze persistenti |
| Storage | `file_picker` | 9.2.0 | Dialog selezione file |
| Biometria | `local_auth` | 2.3.0 | Autenticazione biometrica nativa |
| OTP | `otp` | 3.1.4 | Generazione TOTP/HOTP |
| Export | `pdf` + `printing` | 3.11.2 / 5.13.4 | Generazione PDF e stampa |
| CSV | `csv` | 6.0.0 | Import/export CSV |
| Cloud | `googleapis` | 14.0.0 | Google Drive API |
| Cloud | `webdav_client` | 1.2.2 | Supporto WebDAV |
| UI | `wakelock_plus` | 1.5.2 | Schermo sempre acceso |
| UI | `mobile_scanner` | 7.2.0 | Scansione QR per URI TOTP |
| Autofill | `flutter_autofill_service` | 0.21.0 | Android Autofill Framework |