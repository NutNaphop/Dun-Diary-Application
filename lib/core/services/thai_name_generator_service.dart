// shared/utils/thai_name_generator.dart

import 'dart:math';
import 'package:flutter/services.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';

class ThaiNameGenerator {
  ThaiNameGenerator._();

  static Future<String> generate() async {
    try {
      final results = await Future.wait([
        rootBundle.loadString('assets/texts/nouns.txt'),
        rootBundle.loadString('assets/texts/adjectives.txt'),
      ]);

      final List<String> nouns = results[0]
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final List<String> adjectives = results[1]
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final random = Random();

      final noun = nouns.isNotEmpty
          ? nouns[random.nextInt(nouns.length)]
          : 'ผู้ใช้งาน';
      final adjective = adjectives.isNotEmpty
          ? adjectives[random.nextInt(adjectives.length)]
          : 'ทั่วไป';

      return '$noun$adjective';
    } catch (e) {
      AppLogger.error("Error reading names TXT: $e");
      return 'ผู้ใช้งานทั่วไป';
    }
  }
}
