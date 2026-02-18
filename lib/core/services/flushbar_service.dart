import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/shared/widgets/custom/snackbar/custom_flushbar.dart';
import 'package:flutter/material.dart';

class FlushbarService {
  static final FlushbarService instance = FlushbarService._();
  FlushbarService._();

  // --- Public Methods ---

  void showSuccess(String message, {BuildContext? context}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = context ?? NavigationService.instance.globalContext;
      if (ctx != null) {
        CustomFlushbar.create(
          ctx,
          message: message,
          type: FlushbarType.success,
        ).show(ctx);
      }
    });
  }

  void showError(String message, {BuildContext? context}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = context ?? NavigationService.instance.globalContext;
      if (ctx != null) {
        CustomFlushbar.create(
          ctx,
          message: message,
          type: FlushbarType.error,
        ).show(ctx);
      }
    });
  }

  void showWarning(String message, {BuildContext? context}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = context ?? NavigationService.instance.globalContext;
      if (ctx != null) {
        CustomFlushbar.create(
          ctx,
          message: message,
          type: FlushbarType.warning,
        ).show(ctx);
      }
    });
  }

  void showInfo(String message, {BuildContext? context}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = context ?? NavigationService.instance.globalContext;
      if (ctx != null) {
        CustomFlushbar.create(
          ctx,
          message: message,
          type: FlushbarType.info,
        ).show(ctx);
      }
    });
  }
}
