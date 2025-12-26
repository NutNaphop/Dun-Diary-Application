import 'package:flutter/material.dart';
import 'navigation_service.dart'; // import เพื่อดึง context

class DialogService {
  static final DialogService instance = DialogService._();
  DialogService._();

  // Helper ดึง Context
  BuildContext? get _context => NavigationService.instance.globalContext;

  Future<void> showWarning(String title, String message) {
    if (_context == null) return Future.value();

    return showDialog(
      context: _context!,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(color: Colors.orange)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('เข้าใจแล้ว'),
          ),
        ],
      ),
    );
  }

  Future<bool> showConfirm(String title, String message) async {
    if (_context == null) return false;

    return await showDialog<bool>(
      context: _context!,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ยืนยัน'),
          ),
        ],
      ),
    ) ?? false; // ถ้ากดปิด dialog โดยไม่เลือก ให้ถือว่าเป็น false
  }

  // แสดง Loading แบบกดปิดเองไม่ได้
  void showLoading() {
    if (_context == null) return;
    showDialog(
      context: _context!,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // ปิด Dialog
  void closeDialog() {
    if (_context == null) return;
    // เช็คก่อนว่ามี Dialog เปิดอยู่ไหมเพื่อป้องกัน error
    if (Navigator.canPop(_context!)) {
      Navigator.pop(_context!);
    }
  }
}