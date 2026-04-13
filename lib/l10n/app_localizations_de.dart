// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Passwort-Manager';

  @override
  String get unlock => 'Entsperren';

  @override
  String get masterPassword => 'Master-Passwort';

  @override
  String get enterMasterPassword => 'Master-Passwort eingeben';

  @override
  String get confirmMasterPassword => 'Master-Passwort bestätigen';

  @override
  String get wrongPassword => 'Falsches Passwort';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get biometricPromptTitle => 'Biometrische Entsperrung';

  @override
  String get biometricPromptSubtitle =>
      'Verwenden Sie Ihren Fingerabdruck zum Entsperren';

  @override
  String get biometricFailed => 'Biometrische Authentifizierung fehlgeschlagen';

  @override
  String get enterPasswordForBiometric =>
      'Geben Sie das Master-Passwort ein, um die biometrische Entsperrung zu aktivieren';

  @override
  String get createDatabase => 'Neue Datenbank erstellen';

  @override
  String get openDatabase => 'Datenbank öffnen';

  @override
  String get recentDatabases => 'Letzte Datenbanken';

  @override
  String get databaseName => 'Datenbankname';

  @override
  String get groups => 'Gruppen';

  @override
  String get allEntries => 'Alle Einträge';

  @override
  String get entries => 'Einträge';

  @override
  String get noEntries => 'Keine Einträge';

  @override
  String get search => 'Suchen';

  @override
  String get searchEntries => 'Einträge suchen...';

  @override
  String get title => 'Titel';

  @override
  String get username => 'Benutzername';

  @override
  String get password => 'Passwort';

  @override
  String get url => 'URL';

  @override
  String get notes => 'Notizen';

  @override
  String get customFields => 'Benutzerdefinierte Felder';

  @override
  String get addCustomField => 'Feld hinzufügen';

  @override
  String get fieldName => 'Feldname';

  @override
  String get fieldValue => 'Wert';

  @override
  String get protectedField => 'Geschütztes Feld';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get copy => 'Kopieren';

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get clipboardCleared => 'Zwischenablage gelöscht';

  @override
  String get addEntry => 'Eintrag hinzufügen';

  @override
  String get editEntry => 'Eintrag bearbeiten';

  @override
  String get deleteEntry => 'Eintrag löschen';

  @override
  String get deleteEntryConfirm =>
      'Sind Sie sicher, dass Sie diesen Eintrag löschen möchten?';

  @override
  String get addGroup => 'Gruppe hinzufügen';

  @override
  String get editGroup => 'Gruppe bearbeiten';

  @override
  String get deleteGroup => 'Gruppe löschen';

  @override
  String get deleteGroupConfirm =>
      'Sind Sie sicher, dass Sie diese Gruppe und alle Einträge löschen möchten?';

  @override
  String get groupName => 'Gruppenname';

  @override
  String get moveToGroup => 'In Gruppe verschieben';

  @override
  String get settings => 'Einstellungen';

  @override
  String get security => 'Sicherheit';

  @override
  String get biometricUnlock => 'Biometrische Entsperrung';

  @override
  String get autoLockTimeout => 'Automatische Sperre';

  @override
  String get clipboardClearDelay => 'Zwischenablage löschen';

  @override
  String get immediately => 'Sofort';

  @override
  String seconds(int count) {
    return '$count Sekunden';
  }

  @override
  String minutes(int count) {
    return '$count Minuten';
  }

  @override
  String get never => 'Nie';

  @override
  String get theme => 'Design';

  @override
  String get lightTheme => 'Hell';

  @override
  String get darkTheme => 'Dunkel';

  @override
  String get systemTheme => 'System';

  @override
  String get language => 'Sprache';

  @override
  String get databaseInfo => 'Datenbank-Info';

  @override
  String get changeMasterPassword => 'Master-Passwort ändern';

  @override
  String get currentPassword => 'Aktuelles Passwort';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get export => 'Exportieren';

  @override
  String get import => 'Importieren';

  @override
  String get importFromOldApp => 'Aus vorheriger App importieren';

  @override
  String get importFromCsv => 'Aus CSV importieren';

  @override
  String importSuccess(int count) {
    return 'Import abgeschlossen: $count Einträge importiert';
  }

  @override
  String get exportSuccess => 'Datenbank erfolgreich exportiert';

  @override
  String get passwordGenerator => 'Passwort-Generator';

  @override
  String get generatePassword => 'Passwort generieren';

  @override
  String get passwordLength => 'Länge';

  @override
  String get uppercase => 'Großbuchstaben';

  @override
  String get lowercase => 'Kleinbuchstaben';

  @override
  String get digits => 'Ziffern';

  @override
  String get symbols => 'Symbole';

  @override
  String get excludeChars => 'Zeichen ausschließen';

  @override
  String get passphraseMode => 'Passphrase-Modus';

  @override
  String get wordCount => 'Wortanzahl';

  @override
  String get separator => 'Trennzeichen';

  @override
  String get passwordStrength => 'Passwortstärke';

  @override
  String get weak => 'Schwach';

  @override
  String get fair => 'Mittel';

  @override
  String get strong => 'Stark';

  @override
  String get veryStrong => 'Sehr stark';

  @override
  String get totp => 'TOTP-Code';

  @override
  String get addTotp => 'TOTP hinzufügen';

  @override
  String get scanQrCode => 'QR-Code scannen';

  @override
  String get enterTotpManually => 'Manuell eingeben';

  @override
  String get totpSecret => 'Geheimer Schlüssel';

  @override
  String get totpCopied => 'TOTP-Code kopiert';

  @override
  String get attachments => 'Anhänge';

  @override
  String get addAttachment => 'Anhang hinzufügen';

  @override
  String get removeAttachment => 'Anhang entfernen';

  @override
  String get downloadAttachment => 'Anhang herunterladen';

  @override
  String get attachmentAdded => 'Anhang hinzugefügt';

  @override
  String get attachmentRemoved => 'Anhang entfernt';

  @override
  String get cloudSync => 'Cloud-Synchronisierung';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get dropbox => 'Dropbox';

  @override
  String get webdav => 'WebDAV';

  @override
  String get syncNow => 'Jetzt synchronisieren';

  @override
  String lastSync(String date) {
    return 'Letzte Synchronisierung: $date';
  }

  @override
  String get syncConflict => 'Synchronisierungskonflikt';

  @override
  String get keepLocal => 'Lokal behalten';

  @override
  String get keepRemote => 'Remote behalten';

  @override
  String get merge => 'Zusammenführen';

  @override
  String get autofill => 'Automatisch ausfüllen';

  @override
  String get enableAutofill => 'Automatisches Ausfüllen aktivieren';

  @override
  String get autofillServiceDescription =>
      'Verwenden Sie den Passwort-Manager, um Anmeldedaten in anderen Apps automatisch auszufüllen';

  @override
  String get history => 'Verlauf';

  @override
  String get entryHistory => 'Eintragsverlauf';

  @override
  String get restoreVersion => 'Version wiederherstellen';

  @override
  String get createdAt => 'Erstellt am';

  @override
  String get modifiedAt => 'Geändert am';

  @override
  String get accounts => 'Konten';

  @override
  String get creditCards => 'Kreditkarten';

  @override
  String get secureNotes => 'Sichere Notizen';

  @override
  String get cardNumber => 'Kartennummer';

  @override
  String get cardHolder => 'Karteninhaber';

  @override
  String get expiryDate => 'Ablaufdatum';

  @override
  String get cvv => 'CVV';

  @override
  String get pin => 'PIN';

  @override
  String get circuit => 'Netzwerk';

  @override
  String get filterByGroup => 'Nach Gruppe filtern';

  @override
  String get sortBy => 'Sortieren nach';

  @override
  String get sortByTitle => 'Titel';

  @override
  String get sortByModified => 'Änderungsdatum';

  @override
  String get sortByCreated => 'Erstellungsdatum';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get error => 'Fehler';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get loading => 'Laden...';

  @override
  String get about => 'Über';

  @override
  String get version => 'Version';

  @override
  String get welcomeTitle => 'Willkommen beim Passwort-Manager';

  @override
  String get welcomeSubtitle => 'Ihre Passwörter, sicher und immer dabei';

  @override
  String get welcomeDescription =>
      'Der Passwort-Manager verwendet das KeePass-Format, um Ihre Anmeldedaten, Kreditkarten und Notizen sicher zu speichern — alles verschlüsselt auf Ihrem Gerät.';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get masterPasswordExplanationTitle => 'Ihr Master-Passwort';

  @override
  String get masterPasswordExplanation =>
      'Das Master-Passwort ist das einzige Passwort, das Sie sich merken müssen. Es schützt alle Ihre Daten mit starker Verschlüsselung.';

  @override
  String get masterPasswordWarning =>
      'Wenn Sie dieses Passwort vergessen, gehen Ihre Daten für immer verloren. Es gibt keine Möglichkeit der Wiederherstellung.';

  @override
  String get createYourPassword => 'Erstellen Sie Ihr Passwort';

  @override
  String get onboardingBiometricTitle => 'Schnelles Entsperren';

  @override
  String get onboardingBiometricDescription =>
      'Aktivieren Sie die biometrische Entsperrung, um schnell mit Ihrem Fingerabdruck auf Ihren Tresor zuzugreifen.';

  @override
  String get enableBiometric => 'Aktivieren';

  @override
  String get skipForNow => 'Vorerst überspringen';

  @override
  String get onboardingCompleteTitle => 'Alles bereit!';

  @override
  String get onboardingCompleteDescription =>
      'Ihr Tresor ist bereit. Beginnen Sie damit, Ihre Passwörter und Anmeldedaten hinzuzufügen.';

  @override
  String get letsGo => 'Zu Ihrem Tresor';

  @override
  String get next => 'Weiter';

  @override
  String get stayAwake => 'Bildschirm aktiv halten';

  @override
  String get stayAwakeDescription =>
      'Verhindert das Ausschalten des Bildschirms während die App geöffnet ist';

  @override
  String get allowScreenshots => 'Screenshots erlauben';

  @override
  String get allowScreenshotsDescription =>
      'Erlaubt das Aufnehmen von Screenshots der App (Neustart erforderlich)';

  @override
  String get autoExit => 'Automatisch beenden';

  @override
  String get autoExitDescription =>
      'Schließt die App statt sie nach dem Inaktivitäts-Timeout zu sperren';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get archive => 'Archivieren';

  @override
  String get unarchive => 'Wiederherstellen';

  @override
  String get archivedEntries => 'Archiviert';

  @override
  String get archiveConfirm =>
      'Sind Sie sicher, dass Sie diesen Eintrag archivieren möchten?';

  @override
  String get unarchiveConfirm =>
      'Sind Sie sicher, dass Sie diesen Eintrag wiederherstellen möchten?';

  @override
  String get tags => 'Tags';

  @override
  String get addTag => 'Tag hinzufügen';

  @override
  String get filterByTag => 'Nach Tag filtern';

  @override
  String get noTags => 'Keine Tags';

  @override
  String get exportCsv => 'CSV exportieren';

  @override
  String get exportPdf => 'PDF exportieren';

  @override
  String get printEntry => 'Drucken';

  @override
  String get exportAllPdf => 'Alles als PDF exportieren';

  @override
  String get csvFormatError => 'Ungültiges CSV-Format';

  @override
  String get csvExportSuccess => 'CSV erfolgreich exportiert';

  @override
  String get pdfExportSuccess => 'PDF erfolgreich exportiert';

  @override
  String get group => 'Gruppe';
}
