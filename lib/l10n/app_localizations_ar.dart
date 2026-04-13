// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مدير كلمات المرور';

  @override
  String get unlock => 'فتح القفل';

  @override
  String get masterPassword => 'كلمة المرور الرئيسية';

  @override
  String get enterMasterPassword => 'أدخل كلمة المرور الرئيسية';

  @override
  String get confirmMasterPassword => 'تأكيد كلمة المرور الرئيسية';

  @override
  String get wrongPassword => 'كلمة مرور خاطئة';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get biometricPromptTitle => 'فتح القفل البيومتري';

  @override
  String get biometricPromptSubtitle => 'استخدم بصمة إصبعك لفتح القفل';

  @override
  String get biometricFailed => 'فشل المصادقة البيومترية';

  @override
  String get enterPasswordForBiometric =>
      'أدخل كلمة المرور الرئيسية لتفعيل فتح القفل البيومتري';

  @override
  String get createDatabase => 'إنشاء قاعدة بيانات جديدة';

  @override
  String get openDatabase => 'فتح قاعدة البيانات';

  @override
  String get recentDatabases => 'قواعد البيانات الأخيرة';

  @override
  String get databaseName => 'اسم قاعدة البيانات';

  @override
  String get groups => 'المجموعات';

  @override
  String get allEntries => 'جميع الإدخالات';

  @override
  String get entries => 'الإدخالات';

  @override
  String get noEntries => 'لا توجد إدخالات';

  @override
  String get search => 'بحث';

  @override
  String get searchEntries => 'البحث في الإدخالات...';

  @override
  String get title => 'العنوان';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get url => 'الرابط';

  @override
  String get notes => 'ملاحظات';

  @override
  String get customFields => 'حقول مخصصة';

  @override
  String get addCustomField => 'إضافة حقل';

  @override
  String get fieldName => 'اسم الحقل';

  @override
  String get fieldValue => 'القيمة';

  @override
  String get protectedField => 'حقل محمي';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get copy => 'نسخ';

  @override
  String get copiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String get clipboardCleared => 'تم مسح الحافظة';

  @override
  String get addEntry => 'إضافة إدخال';

  @override
  String get editEntry => 'تعديل الإدخال';

  @override
  String get deleteEntry => 'حذف الإدخال';

  @override
  String get deleteEntryConfirm => 'هل أنت متأكد من حذف هذا الإدخال؟';

  @override
  String get addGroup => 'إضافة مجموعة';

  @override
  String get editGroup => 'تعديل المجموعة';

  @override
  String get deleteGroup => 'حذف المجموعة';

  @override
  String get deleteGroupConfirm =>
      'هل أنت متأكد من حذف هذه المجموعة وجميع إدخالاتها؟';

  @override
  String get groupName => 'اسم المجموعة';

  @override
  String get moveToGroup => 'نقل إلى المجموعة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get security => 'الأمان';

  @override
  String get biometricUnlock => 'فتح القفل البيومتري';

  @override
  String get autoLockTimeout => 'القفل التلقائي';

  @override
  String get clipboardClearDelay => 'مسح الحافظة';

  @override
  String get immediately => 'فوراً';

  @override
  String seconds(int count) {
    return '$count ثانية';
  }

  @override
  String minutes(int count) {
    return '$count دقيقة';
  }

  @override
  String get never => 'أبداً';

  @override
  String get theme => 'السمة';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get darkTheme => 'داكن';

  @override
  String get systemTheme => 'النظام';

  @override
  String get language => 'اللغة';

  @override
  String get databaseInfo => 'معلومات قاعدة البيانات';

  @override
  String get changeMasterPassword => 'تغيير كلمة المرور الرئيسية';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get export => 'تصدير';

  @override
  String get import => 'استيراد';

  @override
  String get importFromOldApp => 'استيراد من التطبيق السابق';

  @override
  String get importFromCsv => 'استيراد من CSV';

  @override
  String importSuccess(int count) {
    return 'اكتمل الاستيراد: تم استيراد $count إدخال';
  }

  @override
  String get exportSuccess => 'تم تصدير قاعدة البيانات بنجاح';

  @override
  String get passwordGenerator => 'مولد كلمات المرور';

  @override
  String get generatePassword => 'توليد كلمة مرور';

  @override
  String get passwordLength => 'الطول';

  @override
  String get uppercase => 'أحرف كبيرة';

  @override
  String get lowercase => 'أحرف صغيرة';

  @override
  String get digits => 'أرقام';

  @override
  String get symbols => 'رموز';

  @override
  String get excludeChars => 'استبعاد أحرف';

  @override
  String get passphraseMode => 'وضع عبارة المرور';

  @override
  String get wordCount => 'عدد الكلمات';

  @override
  String get separator => 'الفاصل';

  @override
  String get passwordStrength => 'قوة كلمة المرور';

  @override
  String get weak => 'ضعيفة';

  @override
  String get fair => 'متوسطة';

  @override
  String get strong => 'قوية';

  @override
  String get veryStrong => 'قوية جداً';

  @override
  String get totp => 'رمز TOTP';

  @override
  String get addTotp => 'إضافة TOTP';

  @override
  String get scanQrCode => 'مسح رمز QR';

  @override
  String get enterTotpManually => 'إدخال يدوي';

  @override
  String get totpSecret => 'المفتاح السري';

  @override
  String get totpCopied => 'تم نسخ رمز TOTP';

  @override
  String get attachments => 'المرفقات';

  @override
  String get addAttachment => 'إضافة مرفق';

  @override
  String get removeAttachment => 'إزالة المرفق';

  @override
  String get downloadAttachment => 'تحميل المرفق';

  @override
  String get attachmentAdded => 'تمت إضافة المرفق';

  @override
  String get attachmentRemoved => 'تمت إزالة المرفق';

  @override
  String get cloudSync => 'المزامنة السحابية';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get dropbox => 'Dropbox';

  @override
  String get webdav => 'WebDAV';

  @override
  String get syncNow => 'مزامنة الآن';

  @override
  String lastSync(String date) {
    return 'آخر مزامنة: $date';
  }

  @override
  String get syncConflict => 'تعارض في المزامنة';

  @override
  String get keepLocal => 'الاحتفاظ بالمحلي';

  @override
  String get keepRemote => 'الاحتفاظ بالبعيد';

  @override
  String get merge => 'دمج';

  @override
  String get autofill => 'الملء التلقائي';

  @override
  String get enableAutofill => 'تفعيل الملء التلقائي';

  @override
  String get autofillServiceDescription =>
      'استخدم مدير كلمات المرور لملء بيانات الاعتماد تلقائياً في التطبيقات الأخرى';

  @override
  String get history => 'السجل';

  @override
  String get entryHistory => 'سجل الإدخال';

  @override
  String get restoreVersion => 'استعادة الإصدار';

  @override
  String get createdAt => 'تاريخ الإنشاء';

  @override
  String get modifiedAt => 'تاريخ التعديل';

  @override
  String get accounts => 'الحسابات';

  @override
  String get creditCards => 'بطاقات الائتمان';

  @override
  String get secureNotes => 'ملاحظات آمنة';

  @override
  String get cardNumber => 'رقم البطاقة';

  @override
  String get cardHolder => 'حامل البطاقة';

  @override
  String get expiryDate => 'تاريخ الانتهاء';

  @override
  String get cvv => 'CVV';

  @override
  String get pin => 'PIN';

  @override
  String get circuit => 'شبكة الدفع';

  @override
  String get filterByGroup => 'تصفية حسب المجموعة';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get sortByTitle => 'العنوان';

  @override
  String get sortByModified => 'تاريخ التعديل';

  @override
  String get sortByCreated => 'تاريخ الإنشاء';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get error => 'خطأ';

  @override
  String get ok => 'موافق';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get about => 'حول';

  @override
  String get version => 'الإصدار';

  @override
  String get welcomeTitle => 'مرحباً بك في مدير كلمات المرور';

  @override
  String get welcomeSubtitle => 'كلمات مرورك آمنة ومعك دائماً';

  @override
  String get welcomeDescription =>
      'يستخدم مدير كلمات المرور تنسيق KeePass لتخزين بيانات الاعتماد وبطاقات الائتمان والملاحظات بشكل آمن — كل شيء مشفر على جهازك.';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get masterPasswordExplanationTitle => 'كلمة المرور الرئيسية';

  @override
  String get masterPasswordExplanation =>
      'كلمة المرور الرئيسية هي كلمة المرور الوحيدة التي تحتاج لتذكرها. تحمي جميع بياناتك بتشفير قوي.';

  @override
  String get masterPasswordWarning =>
      'إذا نسيت هذه الكلمة، ستفقد بياناتك للأبد. لا توجد طريقة لاستعادتها.';

  @override
  String get createYourPassword => 'أنشئ كلمة مرورك';

  @override
  String get onboardingBiometricTitle => 'فتح سريع';

  @override
  String get onboardingBiometricDescription =>
      'فعّل فتح القفل البيومتري للوصول السريع إلى خزنتك ببصمة إصبعك.';

  @override
  String get enableBiometric => 'تفعيل';

  @override
  String get skipForNow => 'تخطي الآن';

  @override
  String get onboardingCompleteTitle => 'كل شيء جاهز!';

  @override
  String get onboardingCompleteDescription =>
      'خزنتك جاهزة. ابدأ بإضافة كلمات المرور وبيانات الاعتماد.';

  @override
  String get letsGo => 'الذهاب إلى الخزنة';

  @override
  String get next => 'التالي';

  @override
  String get stayAwake => 'إبقاء الشاشة مضاءة';

  @override
  String get stayAwakeDescription =>
      'يمنع إيقاف تشغيل الشاشة أثناء فتح التطبيق';

  @override
  String get allowScreenshots => 'السماح بلقطات الشاشة';

  @override
  String get allowScreenshotsDescription =>
      'يسمح بالتقاط لقطات شاشة للتطبيق (يتطلب إعادة تشغيل)';

  @override
  String get autoExit => 'الخروج التلقائي';

  @override
  String get autoExitDescription =>
      'يغلق التطبيق بدلاً من قفله بعد انتهاء مهلة عدم النشاط';

  @override
  String get systemDefault => 'الافتراضي للنظام';

  @override
  String get archive => 'أرشفة';

  @override
  String get unarchive => 'إلغاء الأرشفة';

  @override
  String get archivedEntries => 'المؤرشفة';

  @override
  String get archiveConfirm => 'هل أنت متأكد من أرشفة هذا الإدخال؟';

  @override
  String get unarchiveConfirm => 'هل أنت متأكد من إلغاء أرشفة هذا الإدخال؟';

  @override
  String get tags => 'التصنيفات';

  @override
  String get addTag => 'إضافة تصنيف';

  @override
  String get filterByTag => 'تصفية حسب التصنيف';

  @override
  String get noTags => 'لا توجد تصنيفات';

  @override
  String get exportCsv => 'تصدير CSV';

  @override
  String get exportPdf => 'تصدير PDF';

  @override
  String get printEntry => 'طباعة';

  @override
  String get exportAllPdf => 'تصدير الكل إلى PDF';

  @override
  String get csvFormatError => 'تنسيق CSV غير صالح';

  @override
  String get csvExportSuccess => 'تم تصدير CSV بنجاح';

  @override
  String get pdfExportSuccess => 'تم تصدير PDF بنجاح';

  @override
  String get group => 'المجموعة';
}
