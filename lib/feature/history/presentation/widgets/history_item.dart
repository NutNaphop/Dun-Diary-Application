// lib/feature/history/widgets/history_item_card.dart

import 'package:dun_diary_app/feature/home/data/model/bp_record.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:flutter/material.dart';

class HistoryItemCard extends StatelessWidget {
  final BPRecord record;

  const HistoryItemCard({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ใช้ Utils คำนวณระดับเพื่อเลือกสี (ถ้ายังไม่มี Utils ใช้สีตายตัวไปก่อนได้)
    // สมมติ: 0=เขียว, 1=เหลือง, 2=ส้ม, 3=แดง
    final level = BloodPressureUtils.calculateBloodPressureLevel(record.sys, record.dia);
    final color = _getColorByLevel(level);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // ส่วนแสดงค่าความดัน (ตัวใหญ่ๆ)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Column(
                children: [
                  Text(
                    "${record.sys}",
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      color: color
                    ),
                  ),
                  Container(height: 2, width: 20, color: color), // ขีดคั่น
                  Text(
                    "${record.dia}",
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: color
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // ส่วนรายละเอียด (วันที่ + ชีพจร)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.createdAt.toString(),
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.favorite, size: 16, color: Colors.pink),
                      const SizedBox(width: 4),
                      Text("ชีพจร: ${record.pulse} bpm"),
                    ],
                  ),
                  if (record.note != null && record.note!.isNotEmpty) ...[
                     const SizedBox(height: 4),
                     Text("โน้ต: ${record.note}", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                  ]
                ],
              ),
            ),

            // Icon สถานะ Sync (เผื่อไว้ดูเล่น)
            Icon(
              record.isSynced ? Icons.cloud_done : Icons.cloud_upload,
              color: record.isSynced ? Colors.green : Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorByLevel(int level) {
    switch (level) {
      case 0: return Colors.green;
      case 1: return Colors.green[700]!; // ปกติ (สูงนิดหน่อย)
      case 2: return Colors.orange;
      case 3: return Colors.red;
      default: return Colors.red[900]!;
    }
  }
}