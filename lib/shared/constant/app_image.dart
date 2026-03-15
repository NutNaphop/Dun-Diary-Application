// =========================================
// App Images
// =========================================
class AppImages {
  static const _base = 'assets/images';
  static const profile = _ProfileImages();

  static const emptyFolder = '$_base/empty_folder.svg';
  static const noMatchFound = '$_base/no_match_found.svg';
  static const analyze = '$_base/analyze.svg';
  static const analyzeError = '$_base/analyze_error.svg';
  static const confirmDelete = '$_base/confirm_delete.svg';
  static const homeBackground = '$_base/home_background.png';
  static const profileCover = '$_base/background_cover.png';
  static const faq = '$_base/faq.svg';
  static const warning = '$_base/warning.svg';
  static const upload = '$_base/upload.svg';
}

// =========================================
// Profile Images
// =========================================
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

// =========================================
// App Config Images
// =========================================
class AppConfigImages {
  static const _base = 'assets/appIcon';

  static const logo = '$_base/app_icon.png';
  static const logoWithText = '$_base/logo_with_text.png';
  static const background = '$_base/background.png';
  static const foreground = '$_base/foreground.png';
  static const titleLogo = '$_base/title_logo.png';
}

// =========================================
// Tutorial Images
// =========================================
class TutorialImages {
  TutorialImages._();

  static const _base = 'assets/images/tutorial';
  static const analyze = _AnalyzeTutorialImages();
  static const export = _ExportTutorialImages();
  static const history = _HistoryTutorialImages();
  static const record = _RecordTutorialImages();
  static const recovery = _RecoveryTutorialImages();
}

class _AnalyzeTutorialImages {
  const _AnalyzeTutorialImages();
  static const _base = '${TutorialImages._base}/analyze';

  final String analyze1 = '$_base/analyze_step1.png';
  final String analyze2 = '$_base/analyze_step2.png';
}

class _ExportTutorialImages {
  const _ExportTutorialImages();
  static const _base = '${TutorialImages._base}/export';

  final String export1 = '$_base/export_step1.png';
  final String export2 = '$_base/export_step2.png';
  final String export3 = '$_base/export_step3.png';
}

class _HistoryTutorialImages {
  const _HistoryTutorialImages();
  static const _base = '${TutorialImages._base}/history';

  final String history1 = '$_base/history_step1.png';
  final String history2 = '$_base/history_step2.png';
  final String history3 = '$_base/history_step3.png';
}

class _RecordTutorialImages {
  const _RecordTutorialImages();
  static const _base = '${TutorialImages._base}/record';

  final String record1 = '$_base/record_step1.png';
  final String record2 = '$_base/record_step2.png';
  final String record3 = '$_base/record_step3.png';
  final String record4 = '$_base/record_step4.png';
  final String record5 = '$_base/record_step5.png';
}

class _RecoveryTutorialImages {
  const _RecoveryTutorialImages();
  static const _base = '${TutorialImages._base}/recovery';

  final String recovery1 = '$_base/recovery_step1.png';
  final String recovery2 = '$_base/recovery_step2.png';
  final String recovery3 = '$_base/recovery_step3.png';
  final String recovery4 = '$_base/recovery_step4.png';
  final String recovery5 = '$_base/recovery_step5.png';
}
