// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Password Manager';

  @override
  String get unlock => 'Unlock';

  @override
  String get masterPassword => 'Master Password';

  @override
  String get enterMasterPassword => 'Enter master password';

  @override
  String get confirmMasterPassword => 'Confirm master password';

  @override
  String get wrongPassword => 'Wrong password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get biometricPromptTitle => 'Biometric Unlock';

  @override
  String get biometricPromptSubtitle => 'Use your fingerprint to unlock';

  @override
  String get biometricFailed => 'Biometric authentication failed';

  @override
  String get enterPasswordForBiometric =>
      'Enter master password to enable biometric unlock';

  @override
  String get createDatabase => 'Create new database';

  @override
  String get openDatabase => 'Open database';

  @override
  String get recentDatabases => 'Recent databases';

  @override
  String get databaseName => 'Database name';

  @override
  String get groups => 'Groups';

  @override
  String get allEntries => 'All entries';

  @override
  String get entries => 'Entries';

  @override
  String get noEntries => 'No entries';

  @override
  String get search => 'Search';

  @override
  String get searchEntries => 'Search entries...';

  @override
  String get title => 'Title';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get url => 'URL';

  @override
  String get notes => 'Notes';

  @override
  String get customFields => 'Custom fields';

  @override
  String get addCustomField => 'Add field';

  @override
  String get fieldName => 'Field name';

  @override
  String get fieldValue => 'Value';

  @override
  String get protectedField => 'Protected field';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get copy => 'Copy';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get clipboardCleared => 'Clipboard cleared';

  @override
  String get addEntry => 'Add entry';

  @override
  String get editEntry => 'Edit entry';

  @override
  String get deleteEntry => 'Delete entry';

  @override
  String get deleteEntryConfirm =>
      'Are you sure you want to delete this entry?';

  @override
  String get addGroup => 'Add group';

  @override
  String get editGroup => 'Edit group';

  @override
  String get deleteGroup => 'Delete group';

  @override
  String get deleteGroupConfirm =>
      'Are you sure you want to delete this group and all its entries?';

  @override
  String get groupName => 'Group name';

  @override
  String get moveToGroup => 'Move to group';

  @override
  String get settings => 'Settings';

  @override
  String get security => 'Security';

  @override
  String get biometricUnlock => 'Biometric unlock';

  @override
  String get autoLockTimeout => 'Auto-lock';

  @override
  String get clipboardClearDelay => 'Clipboard clear';

  @override
  String get immediately => 'Immediately';

  @override
  String seconds(int count) {
    return '$count seconds';
  }

  @override
  String minutes(int count) {
    return '$count minutes';
  }

  @override
  String get never => 'Never';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get language => 'Language';

  @override
  String get databaseInfo => 'Database info';

  @override
  String get changeMasterPassword => 'Change master password';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get export => 'Export';

  @override
  String get import => 'Import';

  @override
  String get importFromOldApp => 'Import from previous app';

  @override
  String get importFromCsv => 'Import from CSV';

  @override
  String importSuccess(int count) {
    return 'Import complete: $count entries imported';
  }

  @override
  String get exportSuccess => 'Database exported successfully';

  @override
  String get passwordGenerator => 'Password generator';

  @override
  String get generatePassword => 'Generate password';

  @override
  String get passwordLength => 'Length';

  @override
  String get uppercase => 'Uppercase';

  @override
  String get lowercase => 'Lowercase';

  @override
  String get digits => 'Digits';

  @override
  String get symbols => 'Symbols';

  @override
  String get excludeChars => 'Exclude characters';

  @override
  String get passphraseMode => 'Passphrase mode';

  @override
  String get wordCount => 'Word count';

  @override
  String get separator => 'Separator';

  @override
  String get passwordStrength => 'Password strength';

  @override
  String get weak => 'Weak';

  @override
  String get fair => 'Fair';

  @override
  String get strong => 'Strong';

  @override
  String get veryStrong => 'Very strong';

  @override
  String get totp => 'TOTP Code';

  @override
  String get addTotp => 'Add TOTP';

  @override
  String get scanQrCode => 'Scan QR code';

  @override
  String get enterTotpManually => 'Enter manually';

  @override
  String get totpSecret => 'Secret key';

  @override
  String get totpCopied => 'TOTP code copied';

  @override
  String get attachments => 'Attachments';

  @override
  String get addAttachment => 'Add attachment';

  @override
  String get removeAttachment => 'Remove attachment';

  @override
  String get downloadAttachment => 'Download attachment';

  @override
  String get attachmentAdded => 'Attachment added';

  @override
  String get attachmentRemoved => 'Attachment removed';

  @override
  String get cloudSync => 'Cloud sync';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get dropbox => 'Dropbox';

  @override
  String get webdav => 'WebDAV';

  @override
  String get syncNow => 'Sync now';

  @override
  String lastSync(String date) {
    return 'Last sync: $date';
  }

  @override
  String get syncConflict => 'Sync conflict';

  @override
  String get keepLocal => 'Keep local';

  @override
  String get keepRemote => 'Keep remote';

  @override
  String get merge => 'Merge';

  @override
  String get autofill => 'Autofill';

  @override
  String get enableAutofill => 'Enable autofill';

  @override
  String get autofillServiceDescription =>
      'Use Password Manager to automatically fill in credentials in other apps';

  @override
  String get history => 'History';

  @override
  String get entryHistory => 'Entry history';

  @override
  String get restoreVersion => 'Restore version';

  @override
  String get createdAt => 'Created';

  @override
  String get modifiedAt => 'Modified';

  @override
  String get accounts => 'Accounts';

  @override
  String get creditCards => 'Credit cards';

  @override
  String get secureNotes => 'Secure notes';

  @override
  String get cardNumber => 'Card number';

  @override
  String get cardHolder => 'Card holder';

  @override
  String get expiryDate => 'Expiry date';

  @override
  String get cvv => 'CVV';

  @override
  String get pin => 'PIN';

  @override
  String get circuit => 'Circuit';

  @override
  String get filterByGroup => 'Filter by group';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortByTitle => 'Title';

  @override
  String get sortByModified => 'Modified date';

  @override
  String get sortByCreated => 'Created date';

  @override
  String get noResults => 'No results';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get loading => 'Loading...';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get welcomeTitle => 'Welcome to Password Manager';

  @override
  String get welcomeSubtitle => 'Your passwords, safe and always with you';

  @override
  String get welcomeDescription =>
      'Password Manager uses the KeePass format to securely store your credentials, credit cards, and secure notes — all encrypted on your device.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get masterPasswordExplanationTitle => 'Your Master Password';

  @override
  String get masterPasswordExplanation =>
      'The master password is the only password you need to remember. It protects all your data with strong encryption.';

  @override
  String get masterPasswordWarning =>
      'If you forget this password, your data will be lost forever. There is no way to recover it.';

  @override
  String get createYourPassword => 'Create your password';

  @override
  String get onboardingBiometricTitle => 'Quick Unlock';

  @override
  String get onboardingBiometricDescription =>
      'Enable biometric unlock to access your vault quickly with your fingerprint, without typing the master password every time.';

  @override
  String get enableBiometric => 'Enable';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get onboardingCompleteTitle => 'All set!';

  @override
  String get onboardingCompleteDescription =>
      'Your vault is ready. Start adding your passwords and credentials.';

  @override
  String get letsGo => 'Go to your vault';

  @override
  String get next => 'Next';

  @override
  String get stayAwake => 'Keep screen on';

  @override
  String get stayAwakeDescription =>
      'Prevents the screen from turning off while the app is open';

  @override
  String get allowScreenshots => 'Allow screenshots';

  @override
  String get allowScreenshotsDescription =>
      'Allow capturing screenshots of the app (requires restart)';

  @override
  String get autoExit => 'Auto exit';

  @override
  String get autoExitDescription =>
      'Closes the app instead of locking it after inactivity timeout';

  @override
  String get systemDefault => 'System default';

  @override
  String get archive => 'Archive';

  @override
  String get unarchive => 'Unarchive';

  @override
  String get archivedEntries => 'Archived';

  @override
  String get archiveConfirm => 'Are you sure you want to archive this entry?';

  @override
  String get unarchiveConfirm =>
      'Are you sure you want to unarchive this entry?';

  @override
  String get tags => 'Tags';

  @override
  String get addTag => 'Add tag';

  @override
  String get filterByTag => 'Filter by tag';

  @override
  String get noTags => 'No tags';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get printEntry => 'Print';

  @override
  String get exportAllPdf => 'Export all to PDF';

  @override
  String get csvFormatError => 'Invalid CSV format';

  @override
  String get csvExportSuccess => 'CSV exported successfully';

  @override
  String get pdfExportSuccess => 'PDF exported successfully';

  @override
  String get group => 'Group';
}
