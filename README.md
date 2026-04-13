# Password Manager

Un gestore di password KeePass-compatibile per Android, costruito con Flutter.

## Funzionalità

- **Formato KDBX**: compatibile con KeePass 2.x (KDBX 3.x/4.x)
- **Gruppi e cartelle**: organizzazione gerarchica delle credenziali
- **TOTP/2FA**: supporto per codici OTP con countdown live
- **Campi personalizzati**: campi aggiuntivi con opzione protetto
- **Allegati**: allega file alle voci
- **Generatore password**: password e passphrase con opzioni avanzate
- **Ricerca globale**: ricerca full-text con filtro per gruppo
- **Biometria**: sblocco rapido con impronta digitale/face
- **Tema**: chiaro, scuro, sistema
- **Localizzazione**: italiano e inglese
- **Intent .kdbx**: apri file KDBX direttamente dal file manager
- **Autofill**: servizio autofill Android
- **Cloud sync**: Google Drive, WebDAV (in sviluppo)

## Requisiti

- Flutter SDK >= 3.11
- Android SDK 29+ (Android 10+)

## Build

```bash
flutter pub get
flutter build apk --debug
```

## Struttura

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # MaterialApp.router
├── theme/app_theme.dart         # Material3 tema
├── core/
│   ├── router.dart              # GoRouter config
│   ├── kdbx/kdbx_service.dart   # Operazioni KDBX
│   ├── storage/file_source.dart # Astrazione file I/O
│   ├── auth/                    # Auth + auto-lock
│   ├── crypto/                  # Generatore password
│   └── providers/               # Riverpod settings
└── features/
    ├── unlock/                  # Schermata sblocco
    ├── vault/                   # Selettore database
    ├── home/                    # Lista voci + drawer gruppi
    ├── entries/                 # Dettaglio e form voce
    ├── groups/                  # Gestione gruppi
    ├── search/                  # Ricerca globale
    ├── settings/                # Impostazioni
    └── password_gen/            # Generatore password
```