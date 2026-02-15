import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized logger for the entire app.
///
/// Usage:
/// ```dart
/// AppLogger.info("Saved record");
/// AppLogger.error("Failed to save", e, stackTrace);
/// ```
///
/// Automatically disabled in release builds via [kReleaseMode].
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
    level: kReleaseMode ? Level.off : Level.trace,
  );

  static void trace(String message) => _logger.t(message);
  static void debug(String message) => _logger.d(message);
  static void info(String message) => _logger.i(message);
  static void warning(String message) => _logger.w(message);

  static void error(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);

  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.f(message, error: error, stackTrace: stackTrace);
}
