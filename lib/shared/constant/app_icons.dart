class AppIcons {
  AppIcons._(); // Private constructor ป้องกันการสร้าง instance

  static const _base = 'assets/icons';
  static const bottomNav = _BottomNavigationIcons();
  static const duotone = _DuotoneIcons();
  static const fill = _FillIcons();
  static const outline = _OutlineIcons();
}

class _BottomNavigationIcons {
  const _BottomNavigationIcons();

  static const _path = '${AppIcons._base}/bottom_navigation';

  final addSquared = '$_path/add_squared.svg';
  final chartSquared = '$_path/chart_squared.svg';
  final clipboardList = '$_path/clipboard_list.svg';
  final homeSmile = '$_path/home_smile.svg';
  final plus = '$_path/plus.svg';
  final userCircle = '$_path/user_circle.svg';
}

class _DuotoneIcons {
  const _DuotoneIcons();

  static const _path = '${AppIcons._base}/duotone';

  final addCircle = '$_path/add_circle.svg';
  final graphUp = '$_path/graph_up.svg';
  final graphDown = '$_path/graph_down.svg';
  final pulse = '$_path/pulse.svg';
  final heartPulse = '$_path/heart_pulse.svg';
  final starCircle = '$_path/star_circle.svg';
  final camera = '$_path/camera.svg';
  final image = '$_path/image.svg';
  final danger = '$_path/danger.svg';
  final dangerTriangle = '$_path/danger_triangle.svg';
  final check_circle = '$_path/check_circle.svg';
  final info_circle = '$_path/info_circle.svg';
}

class _FillIcons {
  const _FillIcons();

  static const _path = '${AppIcons._base}/fill';

  final image = '$_path/image.svg';
  final notification = '$_path/notification.svg';
  final sparkle = '$_path/sparkle.svg';
}

class _OutlineIcons {
  const _OutlineIcons();

  static const _path = '${AppIcons._base}/outline';

  final leftArrow = '$_path/left_arrow.svg';
  final rightArrow = '$_path/right_arrow.svg';
  final arrowClockwise = '$_path/arrow_clockwise.svg';
  final x = '$_path/x.svg';
  final calendar = '$_path/calendar.svg';
  final clock = '$_path/clock.svg';
  final camera = '$_path/camera.svg';
  final dotThree = '$_path/dot_three.svg';
  final fileDownload = '$_path/file_download.svg';
  final share = '$_path/share.svg';
}
