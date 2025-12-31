import 'package:dun_diary_app/core/services/snackbar_service.dart';
import 'package:flutter/material.dart';

class NavigationService {
  // 1. Singleton
  static final NavigationService instance = NavigationService._();
  NavigationService._();

  // 2. GlobalKey
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  BuildContext? get globalContext => navigatorKey.currentState?.context;
  
  // 3. ฟังก์ชันเปลี่ยนหน้าต่างๆ (เรียกผ่าน navigatorKey แทน context)
  // ไปหน้าใหม่
  Future<dynamic> pushNamed(String routeName, {dynamic arguments}) {
    SnackBarService.instance.clear();
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  // ไปหน้าใหม่ แล้วลบหน้าเก่าทิ้ง
  Future<dynamic> pushReplacementNamed(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }

  // ล้างทุกหน้าแล้วเริ่มใหม่
  Future<dynamic> pushNamedAndRemoveUntil(String routeName) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false, // ลบเกลี้ยง
    );
  }

  // ย้อนกลับ
  void goBack({dynamic result}) {
    SnackBarService.instance.clear();
    return navigatorKey.currentState!.pop(result);
  }

  // ย้อนกลับไปจนกว่าจะเจอ route ที่กำหนด (เช่น กลับไปหน้า Login หรือ Home)
  void popUntil(String routeName) {
    SnackBarService.instance.clear();
    navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }
}