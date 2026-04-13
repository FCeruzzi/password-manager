import 'package:kdbx/kdbx.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../kdbx/kdbx_service.dart';

class PdfService {
  /// Generate and share/print a PDF for a single entry.
  static Future<void> exportEntryPdf(KdbxEntry entry, KdbxService kdbxService) async {
    final pdf = pw.Document();
    final title = entry.getString(KdbxKeyCommon.TITLE)?.getText() ?? '';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => _buildEntryContent(entry, kdbxService),
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: '$title.pdf');
  }

  /// Print a single entry directly.
  static Future<void> printEntry(KdbxEntry entry, KdbxService kdbxService) async {
    final title = entry.getString(KdbxKeyCommon.TITLE)?.getText() ?? '';

    await Printing.layoutPdf(
      name: title,
      onLayout: (format) async {
        final pdf = pw.Document();
        pdf.addPage(
          pw.Page(
            pageFormat: format,
            build: (context) => _buildEntryContent(entry, kdbxService),
          ),
        );
        return pdf.save();
      },
    );
  }

  /// Generate and share a PDF for the entire vault.
  static Future<void> exportVaultPdf(KdbxService kdbxService) async {
    final entries = kdbxService.getAllEntries(includeArchived: true);
    final pdf = pw.Document();

    // Group entries by parent group
    final grouped = <String, List<KdbxEntry>>{};
    for (final entry in entries) {
      final groupName = entry.parent?.name.get() ?? 'Root';
      grouped.putIfAbsent(groupName, () => []).add(entry);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          final widgets = <pw.Widget>[];

          widgets.add(
            pw.Header(
              level: 0,
              child: pw.Text('Password Manager - Export',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
          );
          widgets.add(pw.SizedBox(height: 8));
          widgets.add(pw.Text('Total entries: ${entries.length}'));
          widgets.add(pw.SizedBox(height: 16));

          for (final group in grouped.entries) {
            widgets.add(
              pw.Header(
                level: 1,
                child: pw.Text(group.key,
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ),
            );

            for (final entry in group.value) {
              widgets.add(_buildEntryRow(entry, kdbxService));
              widgets.add(pw.SizedBox(height: 8));
            }
          }

          return widgets;
        },
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'vault_export.pdf');
  }

  static pw.Widget _buildEntryContent(KdbxEntry entry, KdbxService kdbxService) {
    final title = entry.getString(KdbxKeyCommon.TITLE)?.getText() ?? '';
    final username = entry.getString(KdbxKeyCommon.USER_NAME)?.getText() ?? '';
    final url = entry.getString(KdbxKeyCommon.URL)?.getText() ?? '';
    final notes = entry.getString(KdbxKey('Notes'))?.getText() ?? '';
    final tags = kdbxService.getTags(entry);
    final groupName = entry.parent?.name.get() ?? '';
    final created = entry.times.creationTime.get();
    final modified = entry.times.lastModificationTime.get();

    // Custom fields
    final standardKeys = {
      KdbxKeyCommon.TITLE.key,
      KdbxKeyCommon.USER_NAME.key,
      KdbxKeyCommon.PASSWORD.key,
      KdbxKeyCommon.URL.key,
      'Notes', 'otp', 'OTPAuth', 'TOTP Seed', 'TOTP Settings', '_pm_archived',
    };
    final customFields = entry.stringEntries
        .where((e) => !standardKeys.contains(e.key.key))
        .toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(
          level: 0,
          child: pw.Text(title, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
        ),
        if (groupName.isNotEmpty) _pdfField('Group', groupName),
        if (username.isNotEmpty) _pdfField('Username', username),
        _pdfField('Password', '••••••••'),
        if (url.isNotEmpty) _pdfField('URL', url),
        if (notes.isNotEmpty) ...[
          pw.SizedBox(height: 8),
          pw.Text('Notes', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(notes),
        ],
        if (customFields.isNotEmpty) ...[
          pw.SizedBox(height: 12),
          pw.Text('Custom Fields', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
          pw.SizedBox(height: 4),
          ...customFields.map((cf) => _pdfField(cf.key.key, cf.value?.getText() ?? '')),
        ],
        if (tags.isNotEmpty) ...[
          pw.SizedBox(height: 8),
          _pdfField('Tags', tags.join(', ')),
        ],
        pw.SizedBox(height: 12),
        if (created != null)
          pw.Text('Created: ${_formatDate(created)}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        if (modified != null)
          pw.Text('Modified: ${_formatDate(modified)}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
      ],
    );
  }

  static pw.Widget _buildEntryRow(KdbxEntry entry, KdbxService kdbxService) {
    final title = entry.getString(KdbxKeyCommon.TITLE)?.getText() ?? '';
    final username = entry.getString(KdbxKeyCommon.USER_NAME)?.getText() ?? '';
    final url = entry.getString(KdbxKeyCommon.URL)?.getText() ?? '';
    final tags = kdbxService.getTags(entry);

    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
          if (username.isNotEmpty) pw.Text('User: $username', style: const pw.TextStyle(fontSize: 11)),
          if (url.isNotEmpty) pw.Text('URL: $url', style: const pw.TextStyle(fontSize: 11)),
          if (tags.isNotEmpty) pw.Text('Tags: ${tags.join(", ")}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
        ],
      ),
    );
  }

  static pw.Widget _pdfField(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text('$label:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  static String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
