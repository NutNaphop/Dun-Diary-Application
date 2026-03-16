import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/flushbar_service.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:flutter/material.dart';

mixin RecordNavigationMixin on ChangeNotifier {
  Future<void> redirectToRecord() async {
    final result = await NavigationService.instance.pushNamed(AppRoutes.record);

    if (result == true) {
      await Future.delayed(const Duration(milliseconds: 300));
      FlushbarService.instance.showSuccess("บันทึกข้อมูลสำเร็จ");
    }
    notifyListeners();
  }
}
