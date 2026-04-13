// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Password Manager';

  @override
  String get unlock => 'Sblocca';

  @override
  String get masterPassword => 'Password principale';

  @override
  String get enterMasterPassword => 'Inserisci la password principale';

  @override
  String get confirmMasterPassword => 'Conferma la password principale';

  @override
  String get wrongPassword => 'Password errata';

  @override
  String get passwordsDoNotMatch => 'Le password non corrispondono';

  @override
  String get biometricPromptTitle => 'Sblocco biometrico';

  @override
  String get biometricPromptSubtitle =>
      'Usa la tua impronta digitale per sbloccare';

  @override
  String get biometricFailed => 'Autenticazione biometrica fallita';

  @override
  String get enterPasswordForBiometric =>
      'Inserisci la password principale per abilitare lo sblocco biometrico';

  @override
  String get createDatabase => 'Crea nuovo database';

  @override
  String get openDatabase => 'Apri database';

  @override
  String get recentDatabases => 'Database recenti';

  @override
  String get databaseName => 'Nome del database';

  @override
  String get groups => 'Gruppi';

  @override
  String get allEntries => 'Tutte le voci';

  @override
  String get entries => 'Voci';

  @override
  String get noEntries => 'Nessuna voce';

  @override
  String get search => 'Cerca';

  @override
  String get searchEntries => 'Cerca voci...';

  @override
  String get title => 'Titolo';

  @override
  String get username => 'Nome utente';

  @override
  String get password => 'Password';

  @override
  String get url => 'URL';

  @override
  String get notes => 'Note';

  @override
  String get customFields => 'Campi personalizzati';

  @override
  String get addCustomField => 'Aggiungi campo';

  @override
  String get fieldName => 'Nome campo';

  @override
  String get fieldValue => 'Valore';

  @override
  String get protectedField => 'Campo protetto';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get edit => 'Modifica';

  @override
  String get copy => 'Copia';

  @override
  String get copiedToClipboard => 'Copiato negli appunti';

  @override
  String get clipboardCleared => 'Appunti cancellati';

  @override
  String get addEntry => 'Aggiungi voce';

  @override
  String get editEntry => 'Modifica voce';

  @override
  String get deleteEntry => 'Elimina voce';

  @override
  String get deleteEntryConfirm => 'Sei sicuro di voler eliminare questa voce?';

  @override
  String get addGroup => 'Aggiungi gruppo';

  @override
  String get editGroup => 'Modifica gruppo';

  @override
  String get deleteGroup => 'Elimina gruppo';

  @override
  String get deleteGroupConfirm =>
      'Sei sicuro di voler eliminare questo gruppo e tutte le sue voci?';

  @override
  String get groupName => 'Nome gruppo';

  @override
  String get moveToGroup => 'Sposta nel gruppo';

  @override
  String get settings => 'Impostazioni';

  @override
  String get security => 'Sicurezza';

  @override
  String get biometricUnlock => 'Sblocco biometrico';

  @override
  String get autoLockTimeout => 'Blocco automatico';

  @override
  String get clipboardClearDelay => 'Pulizia appunti';

  @override
  String get immediately => 'Immediatamente';

  @override
  String seconds(int count) {
    return '$count secondi';
  }

  @override
  String minutes(int count) {
    return '$count minuti';
  }

  @override
  String get never => 'Mai';

  @override
  String get theme => 'Tema';

  @override
  String get lightTheme => 'Chiaro';

  @override
  String get darkTheme => 'Scuro';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get language => 'Lingua';

  @override
  String get databaseInfo => 'Informazioni database';

  @override
  String get changeMasterPassword => 'Cambia password principale';

  @override
  String get currentPassword => 'Password attuale';

  @override
  String get newPassword => 'Nuova password';

  @override
  String get export => 'Esporta';

  @override
  String get import => 'Importa';

  @override
  String get importFromOldApp => 'Importa dall\'app precedente';

  @override
  String get importFromCsv => 'Importa da CSV';

  @override
  String importSuccess(int count) {
    return 'Importazione completata: $count voci importate';
  }

  @override
  String get exportSuccess => 'Database esportato con successo';

  @override
  String get passwordGenerator => 'Generatore password';

  @override
  String get generatePassword => 'Genera password';

  @override
  String get passwordLength => 'Lunghezza';

  @override
  String get uppercase => 'Maiuscole';

  @override
  String get lowercase => 'Minuscole';

  @override
  String get digits => 'Numeri';

  @override
  String get symbols => 'Simboli';

  @override
  String get excludeChars => 'Escludi caratteri';

  @override
  String get passphraseMode => 'Modalità passphrase';

  @override
  String get wordCount => 'Numero parole';

  @override
  String get separator => 'Separatore';

  @override
  String get passwordStrength => 'Forza password';

  @override
  String get weak => 'Debole';

  @override
  String get fair => 'Discreta';

  @override
  String get strong => 'Forte';

  @override
  String get veryStrong => 'Molto forte';

  @override
  String get totp => 'Codice TOTP';

  @override
  String get addTotp => 'Aggiungi TOTP';

  @override
  String get scanQrCode => 'Scansiona codice QR';

  @override
  String get enterTotpManually => 'Inserisci manualmente';

  @override
  String get totpSecret => 'Chiave segreta';

  @override
  String get totpCopied => 'Codice TOTP copiato';

  @override
  String get attachments => 'Allegati';

  @override
  String get addAttachment => 'Aggiungi allegato';

  @override
  String get removeAttachment => 'Rimuovi allegato';

  @override
  String get downloadAttachment => 'Scarica allegato';

  @override
  String get attachmentAdded => 'Allegato aggiunto';

  @override
  String get attachmentRemoved => 'Allegato rimosso';

  @override
  String get cloudSync => 'Sincronizzazione cloud';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get dropbox => 'Dropbox';

  @override
  String get webdav => 'WebDAV';

  @override
  String get syncNow => 'Sincronizza ora';

  @override
  String lastSync(String date) {
    return 'Ultima sincronizzazione: $date';
  }

  @override
  String get syncConflict => 'Conflitto di sincronizzazione';

  @override
  String get keepLocal => 'Mantieni locale';

  @override
  String get keepRemote => 'Mantieni remoto';

  @override
  String get merge => 'Unisci';

  @override
  String get autofill => 'Compilazione automatica';

  @override
  String get enableAutofill => 'Abilita compilazione automatica';

  @override
  String get autofillServiceDescription =>
      'Usa Password Manager per compilare automaticamente le credenziali nelle altre app';

  @override
  String get history => 'Cronologia';

  @override
  String get entryHistory => 'Cronologia voce';

  @override
  String get restoreVersion => 'Ripristina versione';

  @override
  String get createdAt => 'Creato il';

  @override
  String get modifiedAt => 'Modificato il';

  @override
  String get accounts => 'Account';

  @override
  String get creditCards => 'Carte di credito';

  @override
  String get secureNotes => 'Note sicure';

  @override
  String get cardNumber => 'Numero carta';

  @override
  String get cardHolder => 'Titolare';

  @override
  String get expiryDate => 'Scadenza';

  @override
  String get cvv => 'CVV';

  @override
  String get pin => 'PIN';

  @override
  String get circuit => 'Circuito';

  @override
  String get filterByGroup => 'Filtra per gruppo';

  @override
  String get sortBy => 'Ordina per';

  @override
  String get sortByTitle => 'Titolo';

  @override
  String get sortByModified => 'Data modifica';

  @override
  String get sortByCreated => 'Data creazione';

  @override
  String get noResults => 'Nessun risultato';

  @override
  String get error => 'Errore';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get loading => 'Caricamento...';

  @override
  String get about => 'Informazioni';

  @override
  String get version => 'Versione';

  @override
  String get welcomeTitle => 'Benvenuto in Password Manager';

  @override
  String get welcomeSubtitle => 'Le tue password, al sicuro e sempre con te';

  @override
  String get welcomeDescription =>
      'Password Manager usa il formato KeePass per conservare in modo sicuro le tue credenziali, carte di credito e note — tutto crittografato sul tuo dispositivo.';

  @override
  String get getStarted => 'Inizia';

  @override
  String get masterPasswordExplanationTitle => 'La tua Password Principale';

  @override
  String get masterPasswordExplanation =>
      'La password principale è l\'unica password che dovrai ricordare. Protegge tutti i tuoi dati con una crittografia forte.';

  @override
  String get masterPasswordWarning =>
      'Se dimentichi questa password, i tuoi dati saranno persi per sempre. Non è possibile recuperarla in alcun modo.';

  @override
  String get createYourPassword => 'Crea la tua password';

  @override
  String get onboardingBiometricTitle => 'Sblocco rapido';

  @override
  String get onboardingBiometricDescription =>
      'Abilita lo sblocco biometrico per accedere al tuo vault rapidamente con l\'impronta digitale, senza digitare ogni volta la password principale.';

  @override
  String get enableBiometric => 'Abilita';

  @override
  String get skipForNow => 'Salta per ora';

  @override
  String get onboardingCompleteTitle => 'Tutto pronto!';

  @override
  String get onboardingCompleteDescription =>
      'Il tuo vault è pronto. Inizia ad aggiungere le tue password e credenziali.';

  @override
  String get letsGo => 'Vai al tuo vault';

  @override
  String get next => 'Avanti';

  @override
  String get stayAwake => 'Mantieni schermo attivo';

  @override
  String get stayAwakeDescription =>
      'Impedisce lo spegnimento dello schermo mentre l\'app è aperta';

  @override
  String get allowScreenshots => 'Consenti screenshot';

  @override
  String get allowScreenshotsDescription =>
      'Permette di catturare screenshot dell\'app (richiede riavvio)';

  @override
  String get autoExit => 'Auto uscita';

  @override
  String get autoExitDescription =>
      'Chiude l\'app invece di bloccarla dopo il timeout di inattività';

  @override
  String get systemDefault => 'Predefinito di sistema';

  @override
  String get archive => 'Archivia';

  @override
  String get unarchive => 'Ripristina';

  @override
  String get archivedEntries => 'Archiviate';

  @override
  String get archiveConfirm => 'Sei sicuro di voler archiviare questa voce?';

  @override
  String get unarchiveConfirm =>
      'Sei sicuro di voler ripristinare questa voce?';

  @override
  String get tags => 'Etichette';

  @override
  String get addTag => 'Aggiungi etichetta';

  @override
  String get filterByTag => 'Filtra per etichetta';

  @override
  String get noTags => 'Nessuna etichetta';

  @override
  String get exportCsv => 'Esporta CSV';

  @override
  String get exportPdf => 'Esporta PDF';

  @override
  String get printEntry => 'Stampa';

  @override
  String get exportAllPdf => 'Esporta tutto in PDF';

  @override
  String get csvFormatError => 'Formato CSV non valido';

  @override
  String get csvExportSuccess => 'CSV esportato con successo';

  @override
  String get pdfExportSuccess => 'PDF esportato con successo';

  @override
  String get group => 'Gruppo';
}
