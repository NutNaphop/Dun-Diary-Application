import 'package:hive/hive.dart';

part 'bp_record.g.dart'; // เดี๋ยวเราจะ Gen ไฟล์นี้

@HiveType(typeId: 1) // เปลี่ยน ID เป็น 1 เพื่อไม่ให้ตีกับของเก่า (ถ้ามี)
class BPRecord extends HiveObject {
  @HiveField(0)
  String id; // ใช้ uuid string หรือ timestamp string

  @HiveField(1)
  String ownerId; // เก็บ ID ที่ได้จาก Phase 1

  @HiveField(2)
  int sys; // ค่าบน

  @HiveField(3)
  int dia; // ค่าล่าง

  @HiveField(4)
  int pulse; // ชีพจร

  @HiveField(5)
  DateTime createdAt; // เวลาที่บันทึก

  @HiveField(6)
  bool isSynced; // ส่งขึ้น Firebase หรือยัง?

  @HiveField(7)
  String? note; // โน้ตเพิ่มเติม (เผื่อไว้)

  BPRecord({
    required this.id,
    required this.ownerId,
    required this.sys,
    required this.dia,
    required this.pulse,
    required this.createdAt,
    this.isSynced = false,
    this.note,
  });
  
  // แปลงเป็น Map สำหรับส่งให้ Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'sys': sys,
      'dia': dia,
      'pulse': pulse,
      'createdAt': createdAt.toIso8601String(),
      'note': note,
    };
  }
}