import 'dart:io';
import 'dart:typed_data';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:gal/gal.dart';
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

  Future<void> exportToImage(Uint8List imageBytes) async {
    try {
      final directory = await getTemporaryDirectory();
      final fileName =
          "bp_summary_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.png";
      final path = '${directory.path}/$fileName';

      final file = File(path);
      await file.writeAsBytes(imageBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(path)],
          text: 'ข้อมูลความดันโลหิต (Dun Diary)',
          subject: 'Export Blood Pressure Data',
        ),
      );
    } catch (e) {
      print("Export Image Error: $e");
      rethrow;
    }
  }

  Future<void> saveToGallery(Uint8List imageBytes) async {
    try {
      await Gal.putImageBytes(
        imageBytes,
        name: "dun_diary_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}",
      );
    } catch (e) {
      print("Save Gallery Error: $e");
      rethrow;
    }
  }

  Future<void> shareImage(Uint8List imageBytes) async {
    try {
      // ต้องเซฟลง Temp ก่อนแชร์เสมอ
      final directory = await getTemporaryDirectory();
      final fileName =
          "bp_summary_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.png";
      final path = '${directory.path}/$fileName';

      final file = File(path);
      await file.writeAsBytes(imageBytes);

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
}
