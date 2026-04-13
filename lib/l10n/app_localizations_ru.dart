// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Менеджер паролей';

  @override
  String get unlock => 'Разблокировать';

  @override
  String get masterPassword => 'Мастер-пароль';

  @override
  String get enterMasterPassword => 'Введите мастер-пароль';

  @override
  String get confirmMasterPassword => 'Подтвердите мастер-пароль';

  @override
  String get wrongPassword => 'Неверный пароль';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get biometricPromptTitle => 'Биометрическая разблокировка';

  @override
  String get biometricPromptSubtitle =>
      'Используйте отпечаток пальца для разблокировки';

  @override
  String get biometricFailed => 'Биометрическая аутентификация не удалась';

  @override
  String get enterPasswordForBiometric =>
      'Введите мастер-пароль для включения биометрической разблокировки';

  @override
  String get createDatabase => 'Создать новую базу данных';

  @override
  String get openDatabase => 'Открыть базу данных';

  @override
  String get recentDatabases => 'Недавние базы данных';

  @override
  String get databaseName => 'Имя базы данных';

  @override
  String get groups => 'Группы';

  @override
  String get allEntries => 'Все записи';

  @override
  String get entries => 'Записи';

  @override
  String get noEntries => 'Нет записей';

  @override
  String get search => 'Поиск';

  @override
  String get searchEntries => 'Поиск записей...';

  @override
  String get title => 'Заголовок';

  @override
  String get username => 'Имя пользователя';

  @override
  String get password => 'Пароль';

  @override
  String get url => 'URL';

  @override
  String get notes => 'Заметки';

  @override
  String get customFields => 'Пользовательские поля';

  @override
  String get addCustomField => 'Добавить поле';

  @override
  String get fieldName => 'Имя поля';

  @override
  String get fieldValue => 'Значение';

  @override
  String get protectedField => 'Защищённое поле';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Изменить';

  @override
  String get copy => 'Копировать';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get clipboardCleared => 'Буфер обмена очищен';

  @override
  String get addEntry => 'Добавить запись';

  @override
  String get editEntry => 'Изменить запись';

  @override
  String get deleteEntry => 'Удалить запись';

  @override
  String get deleteEntryConfirm => 'Вы уверены, что хотите удалить эту запись?';

  @override
  String get addGroup => 'Добавить группу';

  @override
  String get editGroup => 'Изменить группу';

  @override
  String get deleteGroup => 'Удалить группу';

  @override
  String get deleteGroupConfirm =>
      'Вы уверены, что хотите удалить эту группу и все её записи?';

  @override
  String get groupName => 'Имя группы';

  @override
  String get moveToGroup => 'Переместить в группу';

  @override
  String get settings => 'Настройки';

  @override
  String get security => 'Безопасность';

  @override
  String get biometricUnlock => 'Биометрическая разблокировка';

  @override
  String get autoLockTimeout => 'Автоблокировка';

  @override
  String get clipboardClearDelay => 'Очистка буфера обмена';

  @override
  String get immediately => 'Немедленно';

  @override
  String seconds(int count) {
    return '$count секунд';
  }

  @override
  String minutes(int count) {
    return '$count минут';
  }

  @override
  String get never => 'Никогда';

  @override
  String get theme => 'Тема';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get darkTheme => 'Тёмная';

  @override
  String get systemTheme => 'Системная';

  @override
  String get language => 'Язык';

  @override
  String get databaseInfo => 'Информация о базе данных';

  @override
  String get changeMasterPassword => 'Изменить мастер-пароль';

  @override
  String get currentPassword => 'Текущий пароль';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get export => 'Экспорт';

  @override
  String get import => 'Импорт';

  @override
  String get importFromOldApp => 'Импорт из предыдущего приложения';

  @override
  String get importFromCsv => 'Импорт из CSV';

  @override
  String importSuccess(int count) {
    return 'Импорт завершён: импортировано $count записей';
  }

  @override
  String get exportSuccess => 'База данных успешно экспортирована';

  @override
  String get passwordGenerator => 'Генератор паролей';

  @override
  String get generatePassword => 'Сгенерировать пароль';

  @override
  String get passwordLength => 'Длина';

  @override
  String get uppercase => 'Заглавные буквы';

  @override
  String get lowercase => 'Строчные буквы';

  @override
  String get digits => 'Цифры';

  @override
  String get symbols => 'Символы';

  @override
  String get excludeChars => 'Исключить символы';

  @override
  String get passphraseMode => 'Режим парольной фразы';

  @override
  String get wordCount => 'Количество слов';

  @override
  String get separator => 'Разделитель';

  @override
  String get passwordStrength => 'Надёжность пароля';

  @override
  String get weak => 'Слабый';

  @override
  String get fair => 'Средний';

  @override
  String get strong => 'Сильный';

  @override
  String get veryStrong => 'Очень сильный';

  @override
  String get totp => 'Код TOTP';

  @override
  String get addTotp => 'Добавить TOTP';

  @override
  String get scanQrCode => 'Сканировать QR-код';

  @override
  String get enterTotpManually => 'Ввести вручную';

  @override
  String get totpSecret => 'Секретный ключ';

  @override
  String get totpCopied => 'Код TOTP скопирован';

  @override
  String get attachments => 'Вложения';

  @override
  String get addAttachment => 'Добавить вложение';

  @override
  String get removeAttachment => 'Удалить вложение';

  @override
  String get downloadAttachment => 'Скачать вложение';

  @override
  String get attachmentAdded => 'Вложение добавлено';

  @override
  String get attachmentRemoved => 'Вложение удалено';

  @override
  String get cloudSync => 'Облачная синхронизация';

  @override
  String get googleDrive => 'Google Диск';

  @override
  String get dropbox => 'Dropbox';

  @override
  String get webdav => 'WebDAV';

  @override
  String get syncNow => 'Синхронизировать';

  @override
  String lastSync(String date) {
    return 'Последняя синхронизация: $date';
  }

  @override
  String get syncConflict => 'Конфликт синхронизации';

  @override
  String get keepLocal => 'Оставить локальную';

  @override
  String get keepRemote => 'Оставить удалённую';

  @override
  String get merge => 'Объединить';

  @override
  String get autofill => 'Автозаполнение';

  @override
  String get enableAutofill => 'Включить автозаполнение';

  @override
  String get autofillServiceDescription =>
      'Используйте менеджер паролей для автоматического заполнения учётных данных в других приложениях';

  @override
  String get history => 'История';

  @override
  String get entryHistory => 'История записи';

  @override
  String get restoreVersion => 'Восстановить версию';

  @override
  String get createdAt => 'Создано';

  @override
  String get modifiedAt => 'Изменено';

  @override
  String get accounts => 'Аккаунты';

  @override
  String get creditCards => 'Кредитные карты';

  @override
  String get secureNotes => 'Защищённые заметки';

  @override
  String get cardNumber => 'Номер карты';

  @override
  String get cardHolder => 'Держатель карты';

  @override
  String get expiryDate => 'Срок действия';

  @override
  String get cvv => 'CVV';

  @override
  String get pin => 'PIN';

  @override
  String get circuit => 'Платёжная система';

  @override
  String get filterByGroup => 'Фильтр по группе';

  @override
  String get sortBy => 'Сортировка';

  @override
  String get sortByTitle => 'По заголовку';

  @override
  String get sortByModified => 'По дате изменения';

  @override
  String get sortByCreated => 'По дате создания';

  @override
  String get noResults => 'Нет результатов';

  @override
  String get error => 'Ошибка';

  @override
  String get ok => 'ОК';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get loading => 'Загрузка...';

  @override
  String get about => 'О программе';

  @override
  String get version => 'Версия';

  @override
  String get welcomeTitle => 'Добро пожаловать в Менеджер паролей';

  @override
  String get welcomeSubtitle => 'Ваши пароли в безопасности и всегда с вами';

  @override
  String get welcomeDescription =>
      'Менеджер паролей использует формат KeePass для безопасного хранения учётных данных, кредитных карт и заметок — всё зашифровано на вашем устройстве.';

  @override
  String get getStarted => 'Начать';

  @override
  String get masterPasswordExplanationTitle => 'Ваш мастер-пароль';

  @override
  String get masterPasswordExplanation =>
      'Мастер-пароль — единственный пароль, который нужно запомнить. Он защищает все ваши данные надёжным шифрованием.';

  @override
  String get masterPasswordWarning =>
      'Если вы забудете этот пароль, ваши данные будут потеряны навсегда. Восстановление невозможно.';

  @override
  String get createYourPassword => 'Создайте ваш пароль';

  @override
  String get onboardingBiometricTitle => 'Быстрая разблокировка';

  @override
  String get onboardingBiometricDescription =>
      'Включите биометрическую разблокировку для быстрого доступа к хранилищу по отпечатку пальца.';

  @override
  String get enableBiometric => 'Включить';

  @override
  String get skipForNow => 'Пропустить';

  @override
  String get onboardingCompleteTitle => 'Всё готово!';

  @override
  String get onboardingCompleteDescription =>
      'Ваше хранилище готово. Начните добавлять пароли и учётные данные.';

  @override
  String get letsGo => 'Перейти к хранилищу';

  @override
  String get next => 'Далее';

  @override
  String get stayAwake => 'Не выключать экран';

  @override
  String get stayAwakeDescription =>
      'Предотвращает выключение экрана пока приложение открыто';

  @override
  String get allowScreenshots => 'Разрешить снимки экрана';

  @override
  String get allowScreenshotsDescription =>
      'Позволяет делать снимки экрана приложения (требуется перезапуск)';

  @override
  String get autoExit => 'Автоматический выход';

  @override
  String get autoExitDescription =>
      'Закрывает приложение вместо блокировки после тайм-аута бездействия';

  @override
  String get systemDefault => 'Системный по умолчанию';

  @override
  String get archive => 'Архивировать';

  @override
  String get unarchive => 'Разархивировать';

  @override
  String get archivedEntries => 'Архивированные';

  @override
  String get archiveConfirm =>
      'Вы уверены, что хотите архивировать эту запись?';

  @override
  String get unarchiveConfirm =>
      'Вы уверены, что хотите разархивировать эту запись?';

  @override
  String get tags => 'Метки';

  @override
  String get addTag => 'Добавить метку';

  @override
  String get filterByTag => 'Фильтр по метке';

  @override
  String get noTags => 'Нет меток';

  @override
  String get exportCsv => 'Экспорт CSV';

  @override
  String get exportPdf => 'Экспорт PDF';

  @override
  String get printEntry => 'Печать';

  @override
  String get exportAllPdf => 'Экспортировать всё в PDF';

  @override
  String get csvFormatError => 'Неверный формат CSV';

  @override
  String get csvExportSuccess => 'CSV успешно экспортирован';

  @override
  String get pdfExportSuccess => 'PDF успешно экспортирован';

  @override
  String get group => 'Группа';
}
