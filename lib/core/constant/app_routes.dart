class AppRoutes {
  static const String splash = "/";
  static const String main = '/main';
  static const String home = "/home";

  static const String mock = "/mock";

  // Record Feature
  static const String record = "/record";
  static const String result = "/result";

  // History Feature
  static const String history = "/history";

  // Setting Feature
  static const setting = _SettingRoutes();
}

class _SettingRoutes {
  const _SettingRoutes();

  final String root = '/setting';

  String get profile => '$root/profile';
  String get profileEdit => '$profile/edit';

  String get recovery => '$root/recovery';
  String get myQrcode => '$recovery/myqrcode';
  String get recoveryMyData => '$recovery/recoveryMyData';

  String get tutorial => '$root/tutorial';
}
