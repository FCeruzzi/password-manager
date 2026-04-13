// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Gestor de contraseñas';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get masterPassword => 'Contraseña maestra';

  @override
  String get enterMasterPassword => 'Ingrese la contraseña maestra';

  @override
  String get confirmMasterPassword => 'Confirme la contraseña maestra';

  @override
  String get wrongPassword => 'Contraseña incorrecta';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get biometricPromptTitle => 'Desbloqueo biométrico';

  @override
  String get biometricPromptSubtitle =>
      'Use su huella digital para desbloquear';

  @override
  String get biometricFailed => 'La autenticación biométrica falló';

  @override
  String get enterPasswordForBiometric =>
      'Ingrese la contraseña maestra para habilitar el desbloqueo biométrico';

  @override
  String get createDatabase => 'Crear nueva base de datos';

  @override
  String get openDatabase => 'Abrir base de datos';

  @override
  String get recentDatabases => 'Bases de datos recientes';

  @override
  String get databaseName => 'Nombre de la base de datos';

  @override
  String get groups => 'Grupos';

  @override
  String get allEntries => 'Todas las entradas';

  @override
  String get entries => 'Entradas';

  @override
  String get noEntries => 'Sin entradas';

  @override
  String get search => 'Buscar';

  @override
  String get searchEntries => 'Buscar entradas...';

  @override
  String get title => 'Título';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get url => 'URL';

  @override
  String get notes => 'Notas';

  @override
  String get customFields => 'Campos personalizados';

  @override
  String get addCustomField => 'Agregar campo';

  @override
  String get fieldName => 'Nombre del campo';

  @override
  String get fieldValue => 'Valor';

  @override
  String get protectedField => 'Campo protegido';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get copy => 'Copiar';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get clipboardCleared => 'Portapapeles borrado';

  @override
  String get addEntry => 'Agregar entrada';

  @override
  String get editEntry => 'Editar entrada';

  @override
  String get deleteEntry => 'Eliminar entrada';

  @override
  String get deleteEntryConfirm =>
      '¿Está seguro de que desea eliminar esta entrada?';

  @override
  String get addGroup => 'Agregar grupo';

  @override
  String get editGroup => 'Editar grupo';

  @override
  String get deleteGroup => 'Eliminar grupo';

  @override
  String get deleteGroupConfirm =>
      '¿Está seguro de que desea eliminar este grupo y todas sus entradas?';

  @override
  String get groupName => 'Nombre del grupo';

  @override
  String get moveToGroup => 'Mover al grupo';

  @override
  String get settings => 'Configuración';

  @override
  String get security => 'Seguridad';

  @override
  String get biometricUnlock => 'Desbloqueo biométrico';

  @override
  String get autoLockTimeout => 'Bloqueo automático';

  @override
  String get clipboardClearDelay => 'Limpieza del portapapeles';

  @override
  String get immediately => 'Inmediatamente';

  @override
  String seconds(int count) {
    return '$count segundos';
  }

  @override
  String minutes(int count) {
    return '$count minutos';
  }

  @override
  String get never => 'Nunca';

  @override
  String get theme => 'Tema';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Oscuro';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get language => 'Idioma';

  @override
  String get databaseInfo => 'Información de la base de datos';

  @override
  String get changeMasterPassword => 'Cambiar contraseña maestra';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get export => 'Exportar';

  @override
  String get import => 'Importar';

  @override
  String get importFromOldApp => 'Importar desde la app anterior';

  @override
  String get importFromCsv => 'Importar desde CSV';

  @override
  String importSuccess(int count) {
    return 'Importación completada: $count entradas importadas';
  }

  @override
  String get exportSuccess => 'Base de datos exportada con éxito';

  @override
  String get passwordGenerator => 'Generador de contraseñas';

  @override
  String get generatePassword => 'Generar contraseña';

  @override
  String get passwordLength => 'Longitud';

  @override
  String get uppercase => 'Mayúsculas';

  @override
  String get lowercase => 'Minúsculas';

  @override
  String get digits => 'Dígitos';

  @override
  String get symbols => 'Símbolos';

  @override
  String get excludeChars => 'Excluir caracteres';

  @override
  String get passphraseMode => 'Modo frase de paso';

  @override
  String get wordCount => 'Número de palabras';

  @override
  String get separator => 'Separador';

  @override
  String get passwordStrength => 'Fortaleza de la contraseña';

  @override
  String get weak => 'Débil';

  @override
  String get fair => 'Regular';

  @override
  String get strong => 'Fuerte';

  @override
  String get veryStrong => 'Muy fuerte';

  @override
  String get totp => 'Código TOTP';

  @override
  String get addTotp => 'Agregar TOTP';

  @override
  String get scanQrCode => 'Escanear código QR';

  @override
  String get enterTotpManually => 'Ingresar manualmente';

  @override
  String get totpSecret => 'Clave secreta';

  @override
  String get totpCopied => 'Código TOTP copiado';

  @override
  String get attachments => 'Adjuntos';

  @override
  String get addAttachment => 'Agregar adjunto';

  @override
  String get removeAttachment => 'Eliminar adjunto';

  @override
  String get downloadAttachment => 'Descargar adjunto';

  @override
  String get attachmentAdded => 'Adjunto agregado';

  @override
  String get attachmentRemoved => 'Adjunto eliminado';

  @override
  String get cloudSync => 'Sincronización en la nube';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get dropbox => 'Dropbox';

  @override
  String get webdav => 'WebDAV';

  @override
  String get syncNow => 'Sincronizar ahora';

  @override
  String lastSync(String date) {
    return 'Última sincronización: $date';
  }

  @override
  String get syncConflict => 'Conflicto de sincronización';

  @override
  String get keepLocal => 'Mantener local';

  @override
  String get keepRemote => 'Mantener remoto';

  @override
  String get merge => 'Fusionar';

  @override
  String get autofill => 'Autocompletar';

  @override
  String get enableAutofill => 'Activar autocompletar';

  @override
  String get autofillServiceDescription =>
      'Use el gestor de contraseñas para completar automáticamente las credenciales en otras apps';

  @override
  String get history => 'Historial';

  @override
  String get entryHistory => 'Historial de la entrada';

  @override
  String get restoreVersion => 'Restaurar versión';

  @override
  String get createdAt => 'Creado el';

  @override
  String get modifiedAt => 'Modificado el';

  @override
  String get accounts => 'Cuentas';

  @override
  String get creditCards => 'Tarjetas de crédito';

  @override
  String get secureNotes => 'Notas seguras';

  @override
  String get cardNumber => 'Número de tarjeta';

  @override
  String get cardHolder => 'Titular';

  @override
  String get expiryDate => 'Fecha de vencimiento';

  @override
  String get cvv => 'CVV';

  @override
  String get pin => 'PIN';

  @override
  String get circuit => 'Red';

  @override
  String get filterByGroup => 'Filtrar por grupo';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortByTitle => 'Título';

  @override
  String get sortByModified => 'Fecha de modificación';

  @override
  String get sortByCreated => 'Fecha de creación';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get loading => 'Cargando...';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get welcomeTitle => 'Bienvenido al Gestor de Contraseñas';

  @override
  String get welcomeSubtitle => 'Sus contraseñas, seguras y siempre con usted';

  @override
  String get welcomeDescription =>
      'El Gestor de Contraseñas usa el formato KeePass para almacenar de forma segura sus credenciales, tarjetas de crédito y notas — todo cifrado en su dispositivo.';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get masterPasswordExplanationTitle => 'Su contraseña maestra';

  @override
  String get masterPasswordExplanation =>
      'La contraseña maestra es la única contraseña que necesita recordar. Protege todos sus datos con un cifrado fuerte.';

  @override
  String get masterPasswordWarning =>
      'Si olvida esta contraseña, sus datos se perderán para siempre. No hay forma de recuperarla.';

  @override
  String get createYourPassword => 'Cree su contraseña';

  @override
  String get onboardingBiometricTitle => 'Desbloqueo rápido';

  @override
  String get onboardingBiometricDescription =>
      'Active el desbloqueo biométrico para acceder rápidamente a su bóveda con su huella digital.';

  @override
  String get enableBiometric => 'Activar';

  @override
  String get skipForNow => 'Omitir por ahora';

  @override
  String get onboardingCompleteTitle => '¡Todo listo!';

  @override
  String get onboardingCompleteDescription =>
      'Su bóveda está lista. Comience a agregar sus contraseñas y credenciales.';

  @override
  String get letsGo => 'Ir a su bóveda';

  @override
  String get next => 'Siguiente';

  @override
  String get stayAwake => 'Mantener pantalla encendida';

  @override
  String get stayAwakeDescription =>
      'Impide que la pantalla se apague mientras la app está abierta';

  @override
  String get allowScreenshots => 'Permitir capturas de pantalla';

  @override
  String get allowScreenshotsDescription =>
      'Permite capturar capturas de pantalla de la app (requiere reinicio)';

  @override
  String get autoExit => 'Salida automática';

  @override
  String get autoExitDescription =>
      'Cierra la app en lugar de bloquearla después del tiempo de inactividad';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get archive => 'Archivar';

  @override
  String get unarchive => 'Desarchivar';

  @override
  String get archivedEntries => 'Archivadas';

  @override
  String get archiveConfirm =>
      '¿Está seguro de que desea archivar esta entrada?';

  @override
  String get unarchiveConfirm =>
      '¿Está seguro de que desea desarchivar esta entrada?';

  @override
  String get tags => 'Etiquetas';

  @override
  String get addTag => 'Agregar etiqueta';

  @override
  String get filterByTag => 'Filtrar por etiqueta';

  @override
  String get noTags => 'Sin etiquetas';

  @override
  String get exportCsv => 'Exportar CSV';

  @override
  String get exportPdf => 'Exportar PDF';

  @override
  String get printEntry => 'Imprimir';

  @override
  String get exportAllPdf => 'Exportar todo a PDF';

  @override
  String get csvFormatError => 'Formato CSV no válido';

  @override
  String get csvExportSuccess => 'CSV exportado con éxito';

  @override
  String get pdfExportSuccess => 'PDF exportado con éxito';

  @override
  String get group => 'Grupo';
}
