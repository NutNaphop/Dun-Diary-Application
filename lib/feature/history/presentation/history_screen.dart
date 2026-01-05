// lib/feature/history/history_screen.dart

import 'package:dun_diary_app/core/constant/hive_constants.dart';
import 'package:dun_diary_app/feature/history/presentation/widgets/history_item.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติความดัน'),
        centerTitle: true,
      ),
      // ใช้ ValueListenableBuilder ดักฟังการเปลี่ยนแปลงของกล่อง 'bp_records'
      // พอมีข้อมูลใหม่ปุ๊บ หน้านี้จะอัปเดตเองทันที!
      body: ValueListenableBuilder(
        valueListenable: Hive.box<BPRecord>(HiveBoxName.bpRecord).listenable(),
        builder: (context, Box<BPRecord> box, _) {
          
          if (box.values.isEmpty) {
            return const Center(
              child: Text("ยังไม่มีข้อมูล เริ่มบันทึกกันเถอะ!"),
            );
          }

          // แปลงข้อมูลเป็น List และเรียงลำดับ (ใหม่ -> เก่า)
          final records = box.values.toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return ListView.builder(
            itemCount: records.length,
            padding: const EdgeInsets.only(top: 8, bottom: 80), // เผื่อที่ให้ปุ่ม FAB (ถ้ามี)
            itemBuilder: (context, index) {
              final record = records[index];
              return HistoryItemCard(record: record);
            },
          );
        },
      ),
    );
  }
}