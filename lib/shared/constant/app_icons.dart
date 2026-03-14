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

  final String addSquared = '$_path/add_square.svg';
  final String chartSquare = '$_path/chart_square.svg';
  final String clipboardList = '$_path/clipboard_list.svg';
  final String homeSmile = '$_path/home_smile.svg';
  final String userCircle = '$_path/user_circle.svg';
}

class _DuotoneIcons {
  const _DuotoneIcons();

  static const _path = '${AppIcons._base}/duotone';

  final String addCircle = '$_path/add_circle.svg';
  final String graphUp = '$_path/graph_up.svg';
  final String graphDown = '$_path/graph_down.svg';
  final String pulse = '$_path/pulse.svg';
  final String heartPulse = '$_path/heart_pulse.svg';
  final String starCircle = '$_path/star_circle.svg';
  final String camera = '$_path/camera.svg';
  final String image = '$_path/image.svg';
  final String danger = '$_path/danger.svg';
  final String dangerTriangle = '$_path/danger_triangle.svg';
  final String checkCircle = '$_path/check_circle.svg';
  final String infoCircle = '$_path/info_circle.svg';
  final String bin = '$_path/bin.svg';
  final String pen = '$_path/pen.svg';
  final String note = '$_path/note.svg';
  final String qrcode = '$_path/qrcode.svg';
  final String lightbulb = '$_path/lightbulb.svg';
  final String cloudDownload = '$_path/cloud_download.svg';
  final String upload = '$_path/upload.svg';
  final String document = '$_path/document.svg';
}

class _FillIcons {
  const _FillIcons();

  static const _path = '${AppIcons._base}/fill';

  final String image = '$_path/image.svg';
  final String notification = '$_path/notification.svg';
  final String sparkle = '$_path/sparkle.svg';
  final String questionMarkFull = '$_path/question_mark_full.svg';
}

class _OutlineIcons {
  const _OutlineIcons();

  static const _path = '${AppIcons._base}/outline';

  final String leftArrow = '$_path/left_arrow.svg';
  final String rightArrow = '$_path/right_arrow.svg';
  final String arrowClockwise = '$_path/arrow_clockwise.svg';
  final String x = '$_path/x.svg';
  final String calendar = '$_path/calendar.svg';
  final String clock = '$_path/clock.svg';
  final String camera = '$_path/camera.svg';
  final String dotThree = '$_path/dot_three.svg';
  final String fileDownload = '$_path/file_download.svg';
  final String download = '$_path/download.svg';
  final String share = '$_path/share.svg';
  final String pen = '$_path/pen.svg';
  final String bell = '$_path/bell.svg';
  final String infoCircle = '$_path/info_circle.svg';
  final String questionMark = '$_path/question_mark.svg';
  final String image = '$_path/image.svg';
}
