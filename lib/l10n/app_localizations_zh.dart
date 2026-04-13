// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '密码管理器';

  @override
  String get unlock => '解锁';

  @override
  String get masterPassword => '主密码';

  @override
  String get enterMasterPassword => '输入主密码';

  @override
  String get confirmMasterPassword => '确认主密码';

  @override
  String get wrongPassword => '密码错误';

  @override
  String get passwordsDoNotMatch => '密码不匹配';

  @override
  String get biometricPromptTitle => '生物识别解锁';

  @override
  String get biometricPromptSubtitle => '使用指纹解锁';

  @override
  String get biometricFailed => '生物识别认证失败';

  @override
  String get enterPasswordForBiometric => '输入主密码以启用生物识别解锁';

  @override
  String get createDatabase => '创建新数据库';

  @override
  String get openDatabase => '打开数据库';

  @override
  String get recentDatabases => '最近的数据库';

  @override
  String get databaseName => '数据库名称';

  @override
  String get groups => '分组';

  @override
  String get allEntries => '所有条目';

  @override
  String get entries => '条目';

  @override
  String get noEntries => '无条目';

  @override
  String get search => '搜索';

  @override
  String get searchEntries => '搜索条目...';

  @override
  String get title => '标题';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get url => '网址';

  @override
  String get notes => '备注';

  @override
  String get customFields => '自定义字段';

  @override
  String get addCustomField => '添加字段';

  @override
  String get fieldName => '字段名';

  @override
  String get fieldValue => '值';

  @override
  String get protectedField => '受保护字段';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get copy => '复制';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get clipboardCleared => '剪贴板已清除';

  @override
  String get addEntry => '添加条目';

  @override
  String get editEntry => '编辑条目';

  @override
  String get deleteEntry => '删除条目';

  @override
  String get deleteEntryConfirm => '确定要删除此条目吗？';

  @override
  String get addGroup => '添加分组';

  @override
  String get editGroup => '编辑分组';

  @override
  String get deleteGroup => '删除分组';

  @override
  String get deleteGroupConfirm => '确定要删除此分组及其所有条目吗？';

  @override
  String get groupName => '分组名称';

  @override
  String get moveToGroup => '移动到分组';

  @override
  String get settings => '设置';

  @override
  String get security => '安全';

  @override
  String get biometricUnlock => '生物识别解锁';

  @override
  String get autoLockTimeout => '自动锁定';

  @override
  String get clipboardClearDelay => '剪贴板清除';

  @override
  String get immediately => '立即';

  @override
  String seconds(int count) {
    return '$count 秒';
  }

  @override
  String minutes(int count) {
    return '$count 分钟';
  }

  @override
  String get never => '永不';

  @override
  String get theme => '主题';

  @override
  String get lightTheme => '浅色';

  @override
  String get darkTheme => '深色';

  @override
  String get systemTheme => '跟随系统';

  @override
  String get language => '语言';

  @override
  String get databaseInfo => '数据库信息';

  @override
  String get changeMasterPassword => '更改主密码';

  @override
  String get currentPassword => '当前密码';

  @override
  String get newPassword => '新密码';

  @override
  String get export => '导出';

  @override
  String get import => '导入';

  @override
  String get importFromOldApp => '从旧应用导入';

  @override
  String get importFromCsv => '从CSV导入';

  @override
  String importSuccess(int count) {
    return '导入完成：已导入 $count 个条目';
  }

  @override
  String get exportSuccess => '数据库导出成功';

  @override
  String get passwordGenerator => '密码生成器';

  @override
  String get generatePassword => '生成密码';

  @override
  String get passwordLength => '长度';

  @override
  String get uppercase => '大写字母';

  @override
  String get lowercase => '小写字母';

  @override
  String get digits => '数字';

  @override
  String get symbols => '符号';

  @override
  String get excludeChars => '排除字符';

  @override
  String get passphraseMode => '密码短语模式';

  @override
  String get wordCount => '词数';

  @override
  String get separator => '分隔符';

  @override
  String get passwordStrength => '密码强度';

  @override
  String get weak => '弱';

  @override
  String get fair => '一般';

  @override
  String get strong => '强';

  @override
  String get veryStrong => '非常强';

  @override
  String get totp => 'TOTP 验证码';

  @override
  String get addTotp => '添加 TOTP';

  @override
  String get scanQrCode => '扫描二维码';

  @override
  String get enterTotpManually => '手动输入';

  @override
  String get totpSecret => '密钥';

  @override
  String get totpCopied => 'TOTP 验证码已复制';

  @override
  String get attachments => '附件';

  @override
  String get addAttachment => '添加附件';

  @override
  String get removeAttachment => '删除附件';

  @override
  String get downloadAttachment => '下载附件';

  @override
  String get attachmentAdded => '附件已添加';

  @override
  String get attachmentRemoved => '附件已删除';

  @override
  String get cloudSync => '云同步';

  @override
  String get googleDrive => 'Google 云端硬盘';

  @override
  String get dropbox => 'Dropbox';

  @override
  String get webdav => 'WebDAV';

  @override
  String get syncNow => '立即同步';

  @override
  String lastSync(String date) {
    return '上次同步：$date';
  }

  @override
  String get syncConflict => '同步冲突';

  @override
  String get keepLocal => '保留本地';

  @override
  String get keepRemote => '保留远程';

  @override
  String get merge => '合并';

  @override
  String get autofill => '自动填充';

  @override
  String get enableAutofill => '启用自动填充';

  @override
  String get autofillServiceDescription => '使用密码管理器在其他应用中自动填充凭据';

  @override
  String get history => '历史记录';

  @override
  String get entryHistory => '条目历史';

  @override
  String get restoreVersion => '恢复版本';

  @override
  String get createdAt => '创建时间';

  @override
  String get modifiedAt => '修改时间';

  @override
  String get accounts => '账户';

  @override
  String get creditCards => '信用卡';

  @override
  String get secureNotes => '安全笔记';

  @override
  String get cardNumber => '卡号';

  @override
  String get cardHolder => '持卡人';

  @override
  String get expiryDate => '有效期';

  @override
  String get cvv => 'CVV';

  @override
  String get pin => 'PIN';

  @override
  String get circuit => '卡网络';

  @override
  String get filterByGroup => '按分组筛选';

  @override
  String get sortBy => '排序方式';

  @override
  String get sortByTitle => '标题';

  @override
  String get sortByModified => '修改日期';

  @override
  String get sortByCreated => '创建日期';

  @override
  String get noResults => '无结果';

  @override
  String get error => '错误';

  @override
  String get ok => '确定';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get loading => '加载中...';

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get welcomeTitle => '欢迎使用密码管理器';

  @override
  String get welcomeSubtitle => '您的密码，安全且随身携带';

  @override
  String get welcomeDescription =>
      '密码管理器使用 KeePass 格式安全存储您的凭据、信用卡和笔记——全部加密存储在您的设备上。';

  @override
  String get getStarted => '开始使用';

  @override
  String get masterPasswordExplanationTitle => '您的主密码';

  @override
  String get masterPasswordExplanation => '主密码是您唯一需要记住的密码。它使用强加密保护您的所有数据。';

  @override
  String get masterPasswordWarning => '如果您忘记此密码，您的数据将永远丢失。无法恢复。';

  @override
  String get createYourPassword => '创建您的密码';

  @override
  String get onboardingBiometricTitle => '快速解锁';

  @override
  String get onboardingBiometricDescription =>
      '启用生物识别解锁，使用指纹快速访问您的保险库，无需每次输入主密码。';

  @override
  String get enableBiometric => '启用';

  @override
  String get skipForNow => '暂时跳过';

  @override
  String get onboardingCompleteTitle => '一切就绪！';

  @override
  String get onboardingCompleteDescription => '您的保险库已准备就绪。开始添加您的密码和凭据。';

  @override
  String get letsGo => '进入保险库';

  @override
  String get next => '下一步';

  @override
  String get stayAwake => '保持屏幕常亮';

  @override
  String get stayAwakeDescription => '在应用打开时防止屏幕关闭';

  @override
  String get allowScreenshots => '允许截图';

  @override
  String get allowScreenshotsDescription => '允许截取应用截图（需要重启）';

  @override
  String get autoExit => '自动退出';

  @override
  String get autoExitDescription => '在超时后关闭应用而不是锁定';

  @override
  String get systemDefault => '系统默认';

  @override
  String get archive => '归档';

  @override
  String get unarchive => '取消归档';

  @override
  String get archivedEntries => '已归档';

  @override
  String get archiveConfirm => '确定要归档此条目吗？';

  @override
  String get unarchiveConfirm => '确定要取消归档此条目吗？';

  @override
  String get tags => '标签';

  @override
  String get addTag => '添加标签';

  @override
  String get filterByTag => '按标签筛选';

  @override
  String get noTags => '无标签';

  @override
  String get exportCsv => '导出CSV';

  @override
  String get exportPdf => '导出PDF';

  @override
  String get printEntry => '打印';

  @override
  String get exportAllPdf => '导出全部为PDF';

  @override
  String get csvFormatError => 'CSV格式无效';

  @override
  String get csvExportSuccess => 'CSV导出成功';

  @override
  String get pdfExportSuccess => 'PDF导出成功';

  @override
  String get group => '分组';
}
