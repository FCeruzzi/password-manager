// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Gestionnaire de mots de passe';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get masterPassword => 'Mot de passe principal';

  @override
  String get enterMasterPassword => 'Entrez le mot de passe principal';

  @override
  String get confirmMasterPassword => 'Confirmez le mot de passe principal';

  @override
  String get wrongPassword => 'Mot de passe incorrect';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get biometricPromptTitle => 'Déverrouillage biométrique';

  @override
  String get biometricPromptSubtitle =>
      'Utilisez votre empreinte digitale pour déverrouiller';

  @override
  String get biometricFailed => 'L\'authentification biométrique a échoué';

  @override
  String get enterPasswordForBiometric =>
      'Entrez le mot de passe principal pour activer le déverrouillage biométrique';

  @override
  String get createDatabase => 'Créer une nouvelle base de données';

  @override
  String get openDatabase => 'Ouvrir la base de données';

  @override
  String get recentDatabases => 'Bases de données récentes';

  @override
  String get databaseName => 'Nom de la base de données';

  @override
  String get groups => 'Groupes';

  @override
  String get allEntries => 'Toutes les entrées';

  @override
  String get entries => 'Entrées';

  @override
  String get noEntries => 'Aucune entrée';

  @override
  String get search => 'Rechercher';

  @override
  String get searchEntries => 'Rechercher des entrées...';

  @override
  String get title => 'Titre';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get url => 'URL';

  @override
  String get notes => 'Notes';

  @override
  String get customFields => 'Champs personnalisés';

  @override
  String get addCustomField => 'Ajouter un champ';

  @override
  String get fieldName => 'Nom du champ';

  @override
  String get fieldValue => 'Valeur';

  @override
  String get protectedField => 'Champ protégé';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get copy => 'Copier';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get clipboardCleared => 'Presse-papiers effacé';

  @override
  String get addEntry => 'Ajouter une entrée';

  @override
  String get editEntry => 'Modifier l\'entrée';

  @override
  String get deleteEntry => 'Supprimer l\'entrée';

  @override
  String get deleteEntryConfirm =>
      'Êtes-vous sûr de vouloir supprimer cette entrée ?';

  @override
  String get addGroup => 'Ajouter un groupe';

  @override
  String get editGroup => 'Modifier le groupe';

  @override
  String get deleteGroup => 'Supprimer le groupe';

  @override
  String get deleteGroupConfirm =>
      'Êtes-vous sûr de vouloir supprimer ce groupe et toutes ses entrées ?';

  @override
  String get groupName => 'Nom du groupe';

  @override
  String get moveToGroup => 'Déplacer dans le groupe';

  @override
  String get settings => 'Paramètres';

  @override
  String get security => 'Sécurité';

  @override
  String get biometricUnlock => 'Déverrouillage biométrique';

  @override
  String get autoLockTimeout => 'Verrouillage automatique';

  @override
  String get clipboardClearDelay => 'Nettoyage du presse-papiers';

  @override
  String get immediately => 'Immédiatement';

  @override
  String seconds(int count) {
    return '$count secondes';
  }

  @override
  String minutes(int count) {
    return '$count minutes';
  }

  @override
  String get never => 'Jamais';

  @override
  String get theme => 'Thème';

  @override
  String get lightTheme => 'Clair';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get systemTheme => 'Système';

  @override
  String get language => 'Langue';

  @override
  String get databaseInfo => 'Informations sur la base de données';

  @override
  String get changeMasterPassword => 'Changer le mot de passe principal';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get export => 'Exporter';

  @override
  String get import => 'Importer';

  @override
  String get importFromOldApp => 'Importer depuis l\'ancienne app';

  @override
  String get importFromCsv => 'Importer depuis CSV';

  @override
  String importSuccess(int count) {
    return 'Importation terminée : $count entrées importées';
  }

  @override
  String get exportSuccess => 'Base de données exportée avec succès';

  @override
  String get passwordGenerator => 'Générateur de mots de passe';

  @override
  String get generatePassword => 'Générer un mot de passe';

  @override
  String get passwordLength => 'Longueur';

  @override
  String get uppercase => 'Majuscules';

  @override
  String get lowercase => 'Minuscules';

  @override
  String get digits => 'Chiffres';

  @override
  String get symbols => 'Symboles';

  @override
  String get excludeChars => 'Exclure des caractères';

  @override
  String get passphraseMode => 'Mode phrase secrète';

  @override
  String get wordCount => 'Nombre de mots';

  @override
  String get separator => 'Séparateur';

  @override
  String get passwordStrength => 'Force du mot de passe';

  @override
  String get weak => 'Faible';

  @override
  String get fair => 'Moyen';

  @override
  String get strong => 'Fort';

  @override
  String get veryStrong => 'Très fort';

  @override
  String get totp => 'Code TOTP';

  @override
  String get addTotp => 'Ajouter TOTP';

  @override
  String get scanQrCode => 'Scanner le code QR';

  @override
  String get enterTotpManually => 'Saisir manuellement';

  @override
  String get totpSecret => 'Clé secrète';

  @override
  String get totpCopied => 'Code TOTP copié';

  @override
  String get attachments => 'Pièces jointes';

  @override
  String get addAttachment => 'Ajouter une pièce jointe';

  @override
  String get removeAttachment => 'Supprimer la pièce jointe';

  @override
  String get downloadAttachment => 'Télécharger la pièce jointe';

  @override
  String get attachmentAdded => 'Pièce jointe ajoutée';

  @override
  String get attachmentRemoved => 'Pièce jointe supprimée';

  @override
  String get cloudSync => 'Synchronisation cloud';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get dropbox => 'Dropbox';

  @override
  String get webdav => 'WebDAV';

  @override
  String get syncNow => 'Synchroniser maintenant';

  @override
  String lastSync(String date) {
    return 'Dernière synchronisation : $date';
  }

  @override
  String get syncConflict => 'Conflit de synchronisation';

  @override
  String get keepLocal => 'Garder local';

  @override
  String get keepRemote => 'Garder distant';

  @override
  String get merge => 'Fusionner';

  @override
  String get autofill => 'Remplissage automatique';

  @override
  String get enableAutofill => 'Activer le remplissage automatique';

  @override
  String get autofillServiceDescription =>
      'Utilisez le gestionnaire de mots de passe pour remplir automatiquement les identifiants dans les autres apps';

  @override
  String get history => 'Historique';

  @override
  String get entryHistory => 'Historique de l\'entrée';

  @override
  String get restoreVersion => 'Restaurer la version';

  @override
  String get createdAt => 'Créé le';

  @override
  String get modifiedAt => 'Modifié le';

  @override
  String get accounts => 'Comptes';

  @override
  String get creditCards => 'Cartes de crédit';

  @override
  String get secureNotes => 'Notes sécurisées';

  @override
  String get cardNumber => 'Numéro de carte';

  @override
  String get cardHolder => 'Titulaire';

  @override
  String get expiryDate => 'Date d\'expiration';

  @override
  String get cvv => 'CVV';

  @override
  String get pin => 'PIN';

  @override
  String get circuit => 'Réseau';

  @override
  String get filterByGroup => 'Filtrer par groupe';

  @override
  String get sortBy => 'Trier par';

  @override
  String get sortByTitle => 'Titre';

  @override
  String get sortByModified => 'Date de modification';

  @override
  String get sortByCreated => 'Date de création';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get error => 'Erreur';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get loading => 'Chargement...';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get welcomeTitle => 'Bienvenue dans Password Manager';

  @override
  String get welcomeSubtitle =>
      'Vos mots de passe, en sécurité et toujours avec vous';

  @override
  String get welcomeDescription =>
      'Password Manager utilise le format KeePass pour stocker en toute sécurité vos identifiants, cartes de crédit et notes — le tout chiffré sur votre appareil.';

  @override
  String get getStarted => 'Commencer';

  @override
  String get masterPasswordExplanationTitle => 'Votre mot de passe principal';

  @override
  String get masterPasswordExplanation =>
      'Le mot de passe principal est le seul mot de passe dont vous devez vous souvenir. Il protège toutes vos données avec un chiffrement fort.';

  @override
  String get masterPasswordWarning =>
      'Si vous oubliez ce mot de passe, vos données seront perdues à jamais. Il n\'y a aucun moyen de le récupérer.';

  @override
  String get createYourPassword => 'Créez votre mot de passe';

  @override
  String get onboardingBiometricTitle => 'Déverrouillage rapide';

  @override
  String get onboardingBiometricDescription =>
      'Activez le déverrouillage biométrique pour accéder rapidement à votre coffre-fort avec votre empreinte digitale.';

  @override
  String get enableBiometric => 'Activer';

  @override
  String get skipForNow => 'Passer pour le moment';

  @override
  String get onboardingCompleteTitle => 'Tout est prêt !';

  @override
  String get onboardingCompleteDescription =>
      'Votre coffre-fort est prêt. Commencez à ajouter vos mots de passe et identifiants.';

  @override
  String get letsGo => 'Accéder à votre coffre-fort';

  @override
  String get next => 'Suivant';

  @override
  String get stayAwake => 'Garder l\'écran allumé';

  @override
  String get stayAwakeDescription =>
      'Empêche l\'écran de s\'éteindre tant que l\'app est ouverte';

  @override
  String get allowScreenshots => 'Autoriser les captures d\'écran';

  @override
  String get allowScreenshotsDescription =>
      'Permet de capturer des captures d\'écran de l\'app (redémarrage requis)';

  @override
  String get autoExit => 'Sortie automatique';

  @override
  String get autoExitDescription =>
      'Ferme l\'app au lieu de la verrouiller après le délai d\'inactivité';

  @override
  String get systemDefault => 'Par défaut du système';

  @override
  String get archive => 'Archiver';

  @override
  String get unarchive => 'Désarchiver';

  @override
  String get archivedEntries => 'Archivées';

  @override
  String get archiveConfirm =>
      'Êtes-vous sûr de vouloir archiver cette entrée ?';

  @override
  String get unarchiveConfirm =>
      'Êtes-vous sûr de vouloir désarchiver cette entrée ?';

  @override
  String get tags => 'Étiquettes';

  @override
  String get addTag => 'Ajouter une étiquette';

  @override
  String get filterByTag => 'Filtrer par étiquette';

  @override
  String get noTags => 'Aucune étiquette';

  @override
  String get exportCsv => 'Exporter CSV';

  @override
  String get exportPdf => 'Exporter PDF';

  @override
  String get printEntry => 'Imprimer';

  @override
  String get exportAllPdf => 'Tout exporter en PDF';

  @override
  String get csvFormatError => 'Format CSV invalide';

  @override
  String get csvExportSuccess => 'CSV exporté avec succès';

  @override
  String get pdfExportSuccess => 'PDF exporté avec succès';

  @override
  String get group => 'Groupe';
}
