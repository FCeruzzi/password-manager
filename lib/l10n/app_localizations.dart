import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In it, this message translates to:
  /// **'Password Manager'**
  String get appTitle;

  /// No description provided for @unlock.
  ///
  /// In it, this message translates to:
  /// **'Sblocca'**
  String get unlock;

  /// No description provided for @masterPassword.
  ///
  /// In it, this message translates to:
  /// **'Password principale'**
  String get masterPassword;

  /// No description provided for @enterMasterPassword.
  ///
  /// In it, this message translates to:
  /// **'Inserisci la password principale'**
  String get enterMasterPassword;

  /// No description provided for @confirmMasterPassword.
  ///
  /// In it, this message translates to:
  /// **'Conferma la password principale'**
  String get confirmMasterPassword;

  /// No description provided for @wrongPassword.
  ///
  /// In it, this message translates to:
  /// **'Password errata'**
  String get wrongPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In it, this message translates to:
  /// **'Le password non corrispondono'**
  String get passwordsDoNotMatch;

  /// No description provided for @biometricPromptTitle.
  ///
  /// In it, this message translates to:
  /// **'Sblocco biometrico'**
  String get biometricPromptTitle;

  /// No description provided for @biometricPromptSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Usa la tua impronta digitale per sbloccare'**
  String get biometricPromptSubtitle;

  /// No description provided for @biometricFailed.
  ///
  /// In it, this message translates to:
  /// **'Autenticazione biometrica fallita'**
  String get biometricFailed;

  /// No description provided for @enterPasswordForBiometric.
  ///
  /// In it, this message translates to:
  /// **'Inserisci la password principale per abilitare lo sblocco biometrico'**
  String get enterPasswordForBiometric;

  /// No description provided for @createDatabase.
  ///
  /// In it, this message translates to:
  /// **'Crea nuovo database'**
  String get createDatabase;

  /// No description provided for @openDatabase.
  ///
  /// In it, this message translates to:
  /// **'Apri database'**
  String get openDatabase;

  /// No description provided for @recentDatabases.
  ///
  /// In it, this message translates to:
  /// **'Database recenti'**
  String get recentDatabases;

  /// No description provided for @databaseName.
  ///
  /// In it, this message translates to:
  /// **'Nome del database'**
  String get databaseName;

  /// No description provided for @groups.
  ///
  /// In it, this message translates to:
  /// **'Gruppi'**
  String get groups;

  /// No description provided for @allEntries.
  ///
  /// In it, this message translates to:
  /// **'Tutte le voci'**
  String get allEntries;

  /// No description provided for @entries.
  ///
  /// In it, this message translates to:
  /// **'Voci'**
  String get entries;

  /// No description provided for @noEntries.
  ///
  /// In it, this message translates to:
  /// **'Nessuna voce'**
  String get noEntries;

  /// No description provided for @search.
  ///
  /// In it, this message translates to:
  /// **'Cerca'**
  String get search;

  /// No description provided for @searchEntries.
  ///
  /// In it, this message translates to:
  /// **'Cerca voci...'**
  String get searchEntries;

  /// No description provided for @title.
  ///
  /// In it, this message translates to:
  /// **'Titolo'**
  String get title;

  /// No description provided for @username.
  ///
  /// In it, this message translates to:
  /// **'Nome utente'**
  String get username;

  /// No description provided for @password.
  ///
  /// In it, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @url.
  ///
  /// In it, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @notes.
  ///
  /// In it, this message translates to:
  /// **'Note'**
  String get notes;

  /// No description provided for @customFields.
  ///
  /// In it, this message translates to:
  /// **'Campi personalizzati'**
  String get customFields;

  /// No description provided for @addCustomField.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi campo'**
  String get addCustomField;

  /// No description provided for @fieldName.
  ///
  /// In it, this message translates to:
  /// **'Nome campo'**
  String get fieldName;

  /// No description provided for @fieldValue.
  ///
  /// In it, this message translates to:
  /// **'Valore'**
  String get fieldValue;

  /// No description provided for @protectedField.
  ///
  /// In it, this message translates to:
  /// **'Campo protetto'**
  String get protectedField;

  /// No description provided for @save.
  ///
  /// In it, this message translates to:
  /// **'Salva'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In it, this message translates to:
  /// **'Elimina'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In it, this message translates to:
  /// **'Modifica'**
  String get edit;

  /// No description provided for @copy.
  ///
  /// In it, this message translates to:
  /// **'Copia'**
  String get copy;

  /// No description provided for @copiedToClipboard.
  ///
  /// In it, this message translates to:
  /// **'Copiato negli appunti'**
  String get copiedToClipboard;

  /// No description provided for @clipboardCleared.
  ///
  /// In it, this message translates to:
  /// **'Appunti cancellati'**
  String get clipboardCleared;

  /// No description provided for @addEntry.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi voce'**
  String get addEntry;

  /// No description provided for @editEntry.
  ///
  /// In it, this message translates to:
  /// **'Modifica voce'**
  String get editEntry;

  /// No description provided for @deleteEntry.
  ///
  /// In it, this message translates to:
  /// **'Elimina voce'**
  String get deleteEntry;

  /// No description provided for @deleteEntryConfirm.
  ///
  /// In it, this message translates to:
  /// **'Sei sicuro di voler eliminare questa voce?'**
  String get deleteEntryConfirm;

  /// No description provided for @addGroup.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi gruppo'**
  String get addGroup;

  /// No description provided for @editGroup.
  ///
  /// In it, this message translates to:
  /// **'Modifica gruppo'**
  String get editGroup;

  /// No description provided for @deleteGroup.
  ///
  /// In it, this message translates to:
  /// **'Elimina gruppo'**
  String get deleteGroup;

  /// No description provided for @deleteGroupConfirm.
  ///
  /// In it, this message translates to:
  /// **'Sei sicuro di voler eliminare questo gruppo e tutte le sue voci?'**
  String get deleteGroupConfirm;

  /// No description provided for @groupName.
  ///
  /// In it, this message translates to:
  /// **'Nome gruppo'**
  String get groupName;

  /// No description provided for @moveToGroup.
  ///
  /// In it, this message translates to:
  /// **'Sposta nel gruppo'**
  String get moveToGroup;

  /// No description provided for @settings.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get settings;

  /// No description provided for @security.
  ///
  /// In it, this message translates to:
  /// **'Sicurezza'**
  String get security;

  /// No description provided for @biometricUnlock.
  ///
  /// In it, this message translates to:
  /// **'Sblocco biometrico'**
  String get biometricUnlock;

  /// No description provided for @autoLockTimeout.
  ///
  /// In it, this message translates to:
  /// **'Blocco automatico'**
  String get autoLockTimeout;

  /// No description provided for @clipboardClearDelay.
  ///
  /// In it, this message translates to:
  /// **'Pulizia appunti'**
  String get clipboardClearDelay;

  /// No description provided for @immediately.
  ///
  /// In it, this message translates to:
  /// **'Immediatamente'**
  String get immediately;

  /// No description provided for @seconds.
  ///
  /// In it, this message translates to:
  /// **'{count} secondi'**
  String seconds(int count);

  /// No description provided for @minutes.
  ///
  /// In it, this message translates to:
  /// **'{count} minuti'**
  String minutes(int count);

  /// No description provided for @never.
  ///
  /// In it, this message translates to:
  /// **'Mai'**
  String get never;

  /// No description provided for @theme.
  ///
  /// In it, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In it, this message translates to:
  /// **'Chiaro'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In it, this message translates to:
  /// **'Scuro'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In it, this message translates to:
  /// **'Sistema'**
  String get systemTheme;

  /// No description provided for @language.
  ///
  /// In it, this message translates to:
  /// **'Lingua'**
  String get language;

  /// No description provided for @databaseInfo.
  ///
  /// In it, this message translates to:
  /// **'Informazioni database'**
  String get databaseInfo;

  /// No description provided for @changeMasterPassword.
  ///
  /// In it, this message translates to:
  /// **'Cambia password principale'**
  String get changeMasterPassword;

  /// No description provided for @currentPassword.
  ///
  /// In it, this message translates to:
  /// **'Password attuale'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In it, this message translates to:
  /// **'Nuova password'**
  String get newPassword;

  /// No description provided for @export.
  ///
  /// In it, this message translates to:
  /// **'Esporta'**
  String get export;

  /// No description provided for @import.
  ///
  /// In it, this message translates to:
  /// **'Importa'**
  String get import;

  /// No description provided for @importFromOldApp.
  ///
  /// In it, this message translates to:
  /// **'Importa dall\'app precedente'**
  String get importFromOldApp;

  /// No description provided for @importFromCsv.
  ///
  /// In it, this message translates to:
  /// **'Importa da CSV'**
  String get importFromCsv;

  /// No description provided for @importSuccess.
  ///
  /// In it, this message translates to:
  /// **'Importazione completata: {count} voci importate'**
  String importSuccess(int count);

  /// No description provided for @exportSuccess.
  ///
  /// In it, this message translates to:
  /// **'Database esportato con successo'**
  String get exportSuccess;

  /// No description provided for @passwordGenerator.
  ///
  /// In it, this message translates to:
  /// **'Generatore password'**
  String get passwordGenerator;

  /// No description provided for @generatePassword.
  ///
  /// In it, this message translates to:
  /// **'Genera password'**
  String get generatePassword;

  /// No description provided for @passwordLength.
  ///
  /// In it, this message translates to:
  /// **'Lunghezza'**
  String get passwordLength;

  /// No description provided for @uppercase.
  ///
  /// In it, this message translates to:
  /// **'Maiuscole'**
  String get uppercase;

  /// No description provided for @lowercase.
  ///
  /// In it, this message translates to:
  /// **'Minuscole'**
  String get lowercase;

  /// No description provided for @digits.
  ///
  /// In it, this message translates to:
  /// **'Numeri'**
  String get digits;

  /// No description provided for @symbols.
  ///
  /// In it, this message translates to:
  /// **'Simboli'**
  String get symbols;

  /// No description provided for @excludeChars.
  ///
  /// In it, this message translates to:
  /// **'Escludi caratteri'**
  String get excludeChars;

  /// No description provided for @passphraseMode.
  ///
  /// In it, this message translates to:
  /// **'Modalità passphrase'**
  String get passphraseMode;

  /// No description provided for @wordCount.
  ///
  /// In it, this message translates to:
  /// **'Numero parole'**
  String get wordCount;

  /// No description provided for @separator.
  ///
  /// In it, this message translates to:
  /// **'Separatore'**
  String get separator;

  /// No description provided for @passwordStrength.
  ///
  /// In it, this message translates to:
  /// **'Forza password'**
  String get passwordStrength;

  /// No description provided for @weak.
  ///
  /// In it, this message translates to:
  /// **'Debole'**
  String get weak;

  /// No description provided for @fair.
  ///
  /// In it, this message translates to:
  /// **'Discreta'**
  String get fair;

  /// No description provided for @strong.
  ///
  /// In it, this message translates to:
  /// **'Forte'**
  String get strong;

  /// No description provided for @veryStrong.
  ///
  /// In it, this message translates to:
  /// **'Molto forte'**
  String get veryStrong;

  /// No description provided for @totp.
  ///
  /// In it, this message translates to:
  /// **'Codice TOTP'**
  String get totp;

  /// No description provided for @addTotp.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi TOTP'**
  String get addTotp;

  /// No description provided for @scanQrCode.
  ///
  /// In it, this message translates to:
  /// **'Scansiona codice QR'**
  String get scanQrCode;

  /// No description provided for @enterTotpManually.
  ///
  /// In it, this message translates to:
  /// **'Inserisci manualmente'**
  String get enterTotpManually;

  /// No description provided for @totpSecret.
  ///
  /// In it, this message translates to:
  /// **'Chiave segreta'**
  String get totpSecret;

  /// No description provided for @totpCopied.
  ///
  /// In it, this message translates to:
  /// **'Codice TOTP copiato'**
  String get totpCopied;

  /// No description provided for @attachments.
  ///
  /// In it, this message translates to:
  /// **'Allegati'**
  String get attachments;

  /// No description provided for @addAttachment.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi allegato'**
  String get addAttachment;

  /// No description provided for @removeAttachment.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi allegato'**
  String get removeAttachment;

  /// No description provided for @downloadAttachment.
  ///
  /// In it, this message translates to:
  /// **'Scarica allegato'**
  String get downloadAttachment;

  /// No description provided for @attachmentAdded.
  ///
  /// In it, this message translates to:
  /// **'Allegato aggiunto'**
  String get attachmentAdded;

  /// No description provided for @attachmentRemoved.
  ///
  /// In it, this message translates to:
  /// **'Allegato rimosso'**
  String get attachmentRemoved;

  /// No description provided for @cloudSync.
  ///
  /// In it, this message translates to:
  /// **'Sincronizzazione cloud'**
  String get cloudSync;

  /// No description provided for @googleDrive.
  ///
  /// In it, this message translates to:
  /// **'Google Drive'**
  String get googleDrive;

  /// No description provided for @dropbox.
  ///
  /// In it, this message translates to:
  /// **'Dropbox'**
  String get dropbox;

  /// No description provided for @webdav.
  ///
  /// In it, this message translates to:
  /// **'WebDAV'**
  String get webdav;

  /// No description provided for @syncNow.
  ///
  /// In it, this message translates to:
  /// **'Sincronizza ora'**
  String get syncNow;

  /// No description provided for @lastSync.
  ///
  /// In it, this message translates to:
  /// **'Ultima sincronizzazione: {date}'**
  String lastSync(String date);

  /// No description provided for @syncConflict.
  ///
  /// In it, this message translates to:
  /// **'Conflitto di sincronizzazione'**
  String get syncConflict;

  /// No description provided for @keepLocal.
  ///
  /// In it, this message translates to:
  /// **'Mantieni locale'**
  String get keepLocal;

  /// No description provided for @keepRemote.
  ///
  /// In it, this message translates to:
  /// **'Mantieni remoto'**
  String get keepRemote;

  /// No description provided for @merge.
  ///
  /// In it, this message translates to:
  /// **'Unisci'**
  String get merge;

  /// No description provided for @autofill.
  ///
  /// In it, this message translates to:
  /// **'Compilazione automatica'**
  String get autofill;

  /// No description provided for @enableAutofill.
  ///
  /// In it, this message translates to:
  /// **'Abilita compilazione automatica'**
  String get enableAutofill;

  /// No description provided for @autofillServiceDescription.
  ///
  /// In it, this message translates to:
  /// **'Usa Password Manager per compilare automaticamente le credenziali nelle altre app'**
  String get autofillServiceDescription;

  /// No description provided for @history.
  ///
  /// In it, this message translates to:
  /// **'Cronologia'**
  String get history;

  /// No description provided for @entryHistory.
  ///
  /// In it, this message translates to:
  /// **'Cronologia voce'**
  String get entryHistory;

  /// No description provided for @restoreVersion.
  ///
  /// In it, this message translates to:
  /// **'Ripristina versione'**
  String get restoreVersion;

  /// No description provided for @createdAt.
  ///
  /// In it, this message translates to:
  /// **'Creato il'**
  String get createdAt;

  /// No description provided for @modifiedAt.
  ///
  /// In it, this message translates to:
  /// **'Modificato il'**
  String get modifiedAt;

  /// No description provided for @accounts.
  ///
  /// In it, this message translates to:
  /// **'Account'**
  String get accounts;

  /// No description provided for @creditCards.
  ///
  /// In it, this message translates to:
  /// **'Carte di credito'**
  String get creditCards;

  /// No description provided for @secureNotes.
  ///
  /// In it, this message translates to:
  /// **'Note sicure'**
  String get secureNotes;

  /// No description provided for @cardNumber.
  ///
  /// In it, this message translates to:
  /// **'Numero carta'**
  String get cardNumber;

  /// No description provided for @cardHolder.
  ///
  /// In it, this message translates to:
  /// **'Titolare'**
  String get cardHolder;

  /// No description provided for @expiryDate.
  ///
  /// In it, this message translates to:
  /// **'Scadenza'**
  String get expiryDate;

  /// No description provided for @cvv.
  ///
  /// In it, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @pin.
  ///
  /// In it, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @circuit.
  ///
  /// In it, this message translates to:
  /// **'Circuito'**
  String get circuit;

  /// No description provided for @filterByGroup.
  ///
  /// In it, this message translates to:
  /// **'Filtra per gruppo'**
  String get filterByGroup;

  /// No description provided for @sortBy.
  ///
  /// In it, this message translates to:
  /// **'Ordina per'**
  String get sortBy;

  /// No description provided for @sortByTitle.
  ///
  /// In it, this message translates to:
  /// **'Titolo'**
  String get sortByTitle;

  /// No description provided for @sortByModified.
  ///
  /// In it, this message translates to:
  /// **'Data modifica'**
  String get sortByModified;

  /// No description provided for @sortByCreated.
  ///
  /// In it, this message translates to:
  /// **'Data creazione'**
  String get sortByCreated;

  /// No description provided for @noResults.
  ///
  /// In it, this message translates to:
  /// **'Nessun risultato'**
  String get noResults;

  /// No description provided for @error.
  ///
  /// In it, this message translates to:
  /// **'Errore'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In it, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In it, this message translates to:
  /// **'Sì'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In it, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @loading.
  ///
  /// In it, this message translates to:
  /// **'Caricamento...'**
  String get loading;

  /// No description provided for @about.
  ///
  /// In it, this message translates to:
  /// **'Informazioni'**
  String get about;

  /// No description provided for @version.
  ///
  /// In it, this message translates to:
  /// **'Versione'**
  String get version;

  /// No description provided for @welcomeTitle.
  ///
  /// In it, this message translates to:
  /// **'Benvenuto in Password Manager'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Le tue password, al sicuro e sempre con te'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeDescription.
  ///
  /// In it, this message translates to:
  /// **'Password Manager usa il formato KeePass per conservare in modo sicuro le tue credenziali, carte di credito e note — tutto crittografato sul tuo dispositivo.'**
  String get welcomeDescription;

  /// No description provided for @getStarted.
  ///
  /// In it, this message translates to:
  /// **'Inizia'**
  String get getStarted;

  /// No description provided for @masterPasswordExplanationTitle.
  ///
  /// In it, this message translates to:
  /// **'La tua Password Principale'**
  String get masterPasswordExplanationTitle;

  /// No description provided for @masterPasswordExplanation.
  ///
  /// In it, this message translates to:
  /// **'La password principale è l\'unica password che dovrai ricordare. Protegge tutti i tuoi dati con una crittografia forte.'**
  String get masterPasswordExplanation;

  /// No description provided for @masterPasswordWarning.
  ///
  /// In it, this message translates to:
  /// **'Se dimentichi questa password, i tuoi dati saranno persi per sempre. Non è possibile recuperarla in alcun modo.'**
  String get masterPasswordWarning;

  /// No description provided for @createYourPassword.
  ///
  /// In it, this message translates to:
  /// **'Crea la tua password'**
  String get createYourPassword;

  /// No description provided for @onboardingBiometricTitle.
  ///
  /// In it, this message translates to:
  /// **'Sblocco rapido'**
  String get onboardingBiometricTitle;

  /// No description provided for @onboardingBiometricDescription.
  ///
  /// In it, this message translates to:
  /// **'Abilita lo sblocco biometrico per accedere al tuo vault rapidamente con l\'impronta digitale, senza digitare ogni volta la password principale.'**
  String get onboardingBiometricDescription;

  /// No description provided for @enableBiometric.
  ///
  /// In it, this message translates to:
  /// **'Abilita'**
  String get enableBiometric;

  /// No description provided for @skipForNow.
  ///
  /// In it, this message translates to:
  /// **'Salta per ora'**
  String get skipForNow;

  /// No description provided for @onboardingCompleteTitle.
  ///
  /// In it, this message translates to:
  /// **'Tutto pronto!'**
  String get onboardingCompleteTitle;

  /// No description provided for @onboardingCompleteDescription.
  ///
  /// In it, this message translates to:
  /// **'Il tuo vault è pronto. Inizia ad aggiungere le tue password e credenziali.'**
  String get onboardingCompleteDescription;

  /// No description provided for @letsGo.
  ///
  /// In it, this message translates to:
  /// **'Vai al tuo vault'**
  String get letsGo;

  /// No description provided for @next.
  ///
  /// In it, this message translates to:
  /// **'Avanti'**
  String get next;

  /// No description provided for @stayAwake.
  ///
  /// In it, this message translates to:
  /// **'Mantieni schermo attivo'**
  String get stayAwake;

  /// No description provided for @stayAwakeDescription.
  ///
  /// In it, this message translates to:
  /// **'Impedisce lo spegnimento dello schermo mentre l\'app è aperta'**
  String get stayAwakeDescription;

  /// No description provided for @allowScreenshots.
  ///
  /// In it, this message translates to:
  /// **'Consenti screenshot'**
  String get allowScreenshots;

  /// No description provided for @allowScreenshotsDescription.
  ///
  /// In it, this message translates to:
  /// **'Permette di catturare screenshot dell\'app (richiede riavvio)'**
  String get allowScreenshotsDescription;

  /// No description provided for @autoExit.
  ///
  /// In it, this message translates to:
  /// **'Auto uscita'**
  String get autoExit;

  /// No description provided for @autoExitDescription.
  ///
  /// In it, this message translates to:
  /// **'Chiude l\'app invece di bloccarla dopo il timeout di inattività'**
  String get autoExitDescription;

  /// No description provided for @systemDefault.
  ///
  /// In it, this message translates to:
  /// **'Predefinito di sistema'**
  String get systemDefault;

  /// No description provided for @archive.
  ///
  /// In it, this message translates to:
  /// **'Archivia'**
  String get archive;

  /// No description provided for @unarchive.
  ///
  /// In it, this message translates to:
  /// **'Ripristina'**
  String get unarchive;

  /// No description provided for @archivedEntries.
  ///
  /// In it, this message translates to:
  /// **'Archiviate'**
  String get archivedEntries;

  /// No description provided for @archiveConfirm.
  ///
  /// In it, this message translates to:
  /// **'Sei sicuro di voler archiviare questa voce?'**
  String get archiveConfirm;

  /// No description provided for @unarchiveConfirm.
  ///
  /// In it, this message translates to:
  /// **'Sei sicuro di voler ripristinare questa voce?'**
  String get unarchiveConfirm;

  /// No description provided for @tags.
  ///
  /// In it, this message translates to:
  /// **'Etichette'**
  String get tags;

  /// No description provided for @addTag.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi etichetta'**
  String get addTag;

  /// No description provided for @filterByTag.
  ///
  /// In it, this message translates to:
  /// **'Filtra per etichetta'**
  String get filterByTag;

  /// No description provided for @noTags.
  ///
  /// In it, this message translates to:
  /// **'Nessuna etichetta'**
  String get noTags;

  /// No description provided for @exportCsv.
  ///
  /// In it, this message translates to:
  /// **'Esporta CSV'**
  String get exportCsv;

  /// No description provided for @exportPdf.
  ///
  /// In it, this message translates to:
  /// **'Esporta PDF'**
  String get exportPdf;

  /// No description provided for @printEntry.
  ///
  /// In it, this message translates to:
  /// **'Stampa'**
  String get printEntry;

  /// No description provided for @exportAllPdf.
  ///
  /// In it, this message translates to:
  /// **'Esporta tutto in PDF'**
  String get exportAllPdf;

  /// No description provided for @csvFormatError.
  ///
  /// In it, this message translates to:
  /// **'Formato CSV non valido'**
  String get csvFormatError;

  /// No description provided for @csvExportSuccess.
  ///
  /// In it, this message translates to:
  /// **'CSV esportato con successo'**
  String get csvExportSuccess;

  /// No description provided for @pdfExportSuccess.
  ///
  /// In it, this message translates to:
  /// **'PDF esportato con successo'**
  String get pdfExportSuccess;

  /// No description provided for @group.
  ///
  /// In it, this message translates to:
  /// **'Gruppo'**
  String get group;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
