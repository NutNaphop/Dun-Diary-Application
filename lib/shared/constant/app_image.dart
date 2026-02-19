class AppImages {
  static const _base = 'assets/images';
  static const profile = _ProfileImages();

  static const emptyFolder = '$_base/empty_folder.svg';
  static const noMatchFound = '$_base/no_match_found.svg';
  static const analyze = '$_base/analyze.svg';
  static const analyzeError = '$_base/analyze_error.svg';
  static const confirmDelete = '$_base/confirm_delete.svg';
  static const homeBackground = '$_base/home_background.png';
}

class _ProfileImages {
  const _ProfileImages();
  static const _base = "${AppImages._base}/profile";

  final String avatar1 = '$_base/avatar1.png';

  List<String> get all => [avatar1];

  String extractFileName(String fullPath) {
    return fullPath.split('/').last;
  }

  String getFullPath(String fileName) {
    return '$_base/$fileName';
  }
}

class AppConfigImages {
  static const _base = 'assets/appIcon';

  static const logo = '$_base/app_icon.png';
  static const logoWithText = '$_base/logo_with_text.png';
  static const background = '$_base/background.png';
  static const foreground = '$_base/foreground.png';
  static const titleLogo = '$_base/title_logo.png';
}
