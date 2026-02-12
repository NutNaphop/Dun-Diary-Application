import 'dart:io';
import 'dart:typed_data';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  static final ExportService instance = ExportService();
  ExportService();

  Future<void> exportToCsv(List<BPRecord> records, {String? fileName}) async {
    try {
      if (records.isEmpty) throw Exception("No records to export");

      final buffer = StringBuffer();
      buffer.write('\uFEFF');
      buffer.writeln('Date,Time,Systolic,Diastolic,Pulse,Note');

      for (var r in records) {
        final dateStr = DateFormat('yyyy-MM-dd').format(r.createdAt);
        final timeStr = DateFormat('HH:mm').format(r.createdAt);

        final cleanNote = r.note?.replaceAll('"', '""') ?? "";
        final formattedNote = cleanNote.contains(',')
            ? '"$cleanNote"'
            : cleanNote;

        buffer.writeln(
          '$dateStr,$timeStr,${r.sys},${r.dia},${r.pulse},$formattedNote',
        );
      }

      // 2. หา Path และบันทึกไฟล์
      final directory = await getTemporaryDirectory();
      final name =
          fileName ??
          "bp_data_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.csv";
      final path = '${directory.path}/$name';

      final file = File(path);
      await file.writeAsString(buffer.toString());

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(path)],
          text: 'ข้อมูลความดันโลหิต (Dun Diary)',
          subject: 'Export Blood Pressure Data',
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> exportToImage(Uint8List imageBytes, {String? fileName}) async {
    // TODO: Implement Image Saving & Sharing later
    // Logic จะคล้ายๆ CSV คือ:
    // 1. getTemporaryDirectory
    // 2. File(path).writeAsBytes(imageBytes)
    // 3. Share.shareXFiles(...)
  }
}
