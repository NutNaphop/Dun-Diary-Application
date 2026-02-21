class AppStrings {
  AppStrings._();

  // Common
  static const common = _CommonStrings();
  static const bottomNavigation = _BottomNavigationStrings();
  static const bloodPressure = _BloodPressureStrings();

  // SDK
  static const calendar = _CalendarStrings();
  static const bpGraphSdk = _BPGraphStrings();

  // Feature
  static const main = _MainStrings();
  static const home = _HomeStrings();
  static const history = _HistoryStrings();
  static const record = _RecordStrings();
  static const result = _ResultStrings();
  static const stat = _StatStrings();
  static const setting = _SettingStrings();
}

class _CommonStrings {
  const _CommonStrings();

  final String appName = "Dun Diary";

  final String welcomeMessage = "Welcome to Dun Diary";
  final String greeting = "สวัสดี";

  final String date = "วันที่";
  final String time = "เวลา";

  final String error = "เกิดข้อผิดพลาด";
  final String noContentFound = "ไม่พบเนื้อหา";

  final String tryAgain = "ลองอีกครั้ง";
  final String loading = "กำลังโหลด...";

  final String saved = "บันทึกแล้ว";
  final String saving = "กำลังบันทึก...";
  final String save = "บันทึก";
  final String export = "ส่งออก";
  final String share = "แชร์";
  final String cancel = "ยกเลิก";
  final String edit = "แก้ไข";
}

class _BottomNavigationStrings {
  const _BottomNavigationStrings();

  final String home = "หน้าหลัก";
  final String history = "รายการ";
  final String statistic = "สถิติ";
  final String profile = "โปรไฟล์";
}

class _BloodPressureStrings {
  const _BloodPressureStrings();

  String bloodPressure(String label) => "ความดัน $label";
  final String sysTitle = "Systolic";
  final String sysLabel = "Systolic (ตัวบน)";
  final String sysShortLabel = "SYS";
  final String sysUnit = "mmHg";
  final String sysDesc = "ความดันโลหิตขณะหัวใจบีบตัว";

  final String diaTitle = "Diastolic";
  final String diaLabel = "Diastolic (ตัวล่าง)";
  final String diaShortLabel = "DIA";
  final String diaUnit = "mmHg";
  final String diaDesc = "ความดันโลหิตขณะหัวใจคลายตัว";

  final String pulseTitle = "Pulse";
  final String pulseLabel = "Pulse (ชีพจร)";
  final String pulseShortLabel = "PUL";
  final String pulseUnit = "bpm";
  final String pulseDesc = "อัตราการเต้นของหัวใจ";

  final String average = "ค่าเฉลี่ย";
  final String weightLabel = "น้ำหนักตัว";
  final String weightUnit = "kg";

  // Blood Pressure Levels (6 levels: 0-5)
  final String low = "ต่ำ"; // Level 0: SYS < 90 หรือ DIA < 60
  final String normal = "ปกติ"; // Level 1: SYS 90-119 และ DIA 60-79
  final String elevated = "สูง"; // Level 2: SYS 120-129 และ DIA < 80
  final String highStage1 = "สูงระดับ 1"; // Level 3: SYS 130-139 หรือ DIA 80-89
  final String highStage2 =
      "สูงระดับ 2"; // Level 4: SYS 140-179 หรือ DIA 90-119
  final String crisis = "วิกฤต"; // Level 5: SYS >= 180 หรือ DIA >= 120

  // Legacy (for backward compatibility)
  @Deprecated('Use elevated instead')
  final String preHigh = "เริ่มสูง";
  @Deprecated('Use highStage1 or highStage2 instead')
  final String high = "สูง";
  final String danger = "อันตราย";

  // Level Descriptions
  final String lowDesc =
      "ความดันโลหิตต่ำกว่าเกณฑ์\nควรทานอาหารที่มีประโยชน์และพักผ่อนให้เพียงพอ";
  final String normalDesc =
      "ความดันโลหิตปกติ\nสุขภาพแข็งแรงดีมาก รักษาไว้แบบนี้นะครับ";
  final String elevatedDesc =
      "ความดันโลหิตเริ่มสูง (Elevated)\nควรคุมอาหารและออกกำลังกายสม่ำเสมอ";
  final String highStage1Desc =
      "ความดันโลหิตสูงระดับ 1\nควรพบแพทย์และปรับเปลี่ยนพฤติกรรม";
  final String highStage2Desc =
      "ความดันโลหิตสูงระดับ 2\nอันตราย! ควรไปพบแพทย์เพื่อตรวจละเอียด";
  final String crisisDesc =
      "วิกฤตความดันโลหิตสูง (Crisis)\nรีบไปโรงพยาบาลทันที! อันตรายมาก";
}

class _MainStrings {
  const _MainStrings();

  final String addPage = "หน้าเพิ่ม";
  final String statPage = "หน้าสถิติ";
  final String profilePage = "หน้าโปรไฟล์";
}

class _HomeStrings {
  const _HomeStrings();

  String greeting(String name) => "สวัสดี คุณ$name";
  final String recordPressure = "บันทึกความดัน";
  final String healthToday = "สุขภาพของคุณวันนี้";
  final String noContent = "ยังไม่มีการบันทึกวันนี้";
  final String pressToRecord = "กดปุ่มบันทึกเพื่อเริ่มต้น";
  final String recordTodayTogether =
      "บันทึกความดันของวันนี้ เพื่อให้ข้อมูลสุขภาพสมบูรณ์";
}

class _RecordStrings {
  const _RecordStrings();

  final String recordBloodPressure = "บันทึกความดัน";
  final String snapPhoto = "ถ่ายรูปผลวัด";
  final String uploadPhoto = "เลือกรูปจากคลัง";
  final String errorRecord = "เกิดข้อผิดพลาดในการบันทึกข้อมูล";
  final String canNotReadImage = "ไม่สามารถอ่านค่าจากรูปภาพได้";

  final String detailTitle = "รายละเอียด";
  final String editTitle = "แก้ไขข้อมูล";
  final String confirmDeleteTitle = "ลบบันทึกนี้หรือไม่ ?";
  final String confirmDeleteDesc = "ข้อมูลนี้จะถูกลบออกจากประวัติของคุณ";
  final String delete = "ลบ";
}

class _HistoryStrings {
  const _HistoryStrings();

  String signature(String label) => "สร้างโดย $label";
  String printSince(String label) => "พิมพ์เมื่อ: $label";

  final String pageTitle = "รายการบันทึก";
  final String healthReport = "รายงานสุขภาพ";
  final String summarize = "สรุปภาพรวม";
  final String displayGraph = "กราฟแสดงผล";
  final String exportImage = "ส่งออกเป็นรูปภาพ";
  final String exportCsv = "ส่งออกข้อมูล csv";
  final String recordToDevice = "บันทึกลงเครื่อง";

  final String recordTitle = "รายการบันทึกความดัน";
  final String timeRange = "ช่วงเวลา";
  final String startFrom = "เริ่มจาก";
  final String endTo = "จนถึง";
  final String selectMonth = "เลือกเดือน";

  final String saveImageSuccess = "บันทึกรูปภาพสำเร็จ";
  final String saveImageError = "เกิดข้อผิดพลาดในการบันทึกรูปภาพ";
  final String shareImageError = "เกิดข้อผิดพลาดในการแชร์รูปภาพ";
}

class _StatStrings {
  const _StatStrings();

  final String stat = "สถิติ";

  // Summary
  final String healthSummary = "สรุปข้อมูลสุขภาพ";

  // Stat Cards
  final String avgBP = "ค่าเฉลี่ยความดัน";
  final String fluctuation = "การแกว่งตัว";
  final String fluctuationRange = "ระยะการแกว่งตัว";
  final String maxBP = "ค่าสูงสุด";
  final String minBP = "ค่าต่ำสุด";
  final String noData = "ไม่มีข้อมูล";
  final String noDataFound = "ไม่พบข้อมูล";
  final String noDataYet = "ยังไม่มีข้อมูล";
  String recordedOn(String date) => "เมื่อวันที่ $date";
  String bpLevel(String level) => "ความดัน$level";

  // Analyze
  final String aiResult = "ผลวิเคราะห์จาก AI";
  final String suggestions = "คำแนะนำ";
  final String reAnalyze = "วิเคราะห์ผลอีกครั้ง";
  String sourceFrom(String source) => "แหล่งที่มา: $source";

  // Analyze - Idle
  final String idleTitle = "ความดันของคุณเป็นอย่างไรบ้าง";
  final String idleDesc =
      "AI สรุปข้อมูลความดันตลอดสัปดาห์มาให้แล้ว ดูสิว่าช่วงที่ผ่านมาคุณดูแลตัวเองได้ดีแค่ไหน";
  final String startAnalyze = "เริ่มวิเคราะห์ผลความดันด้วย AI";
  final String connectInternet = "เชื่อมต่ออินเตอร์เน็ต เพื่อให้ AI ช่วยสรุปผล";

  // Analyze - Processing
  final String processingTitle = "กำลังประมวลผลสุขภาพ";
  final String processingDesc = "AI กำลังวิเคราะห์ผลเพื่อคุณโดยเฉพาะ";
  final String processingWarning = "กรุณารอสักครู่ อย่าปิดหรือออกจากหน้าจอนี้";

  // Analyze - Error
  final String errorTitle = "ไม่สามารถวิเคราะห์ผลได้ในขณะนี้";
  final String errorDesc =
      "โปรดลองใหม่อีกครั้ง และตรวจสอบการเชื่อมต่ออินเตอร์เน็ตของคุณ";
  final String tryAgain = "ลองใหม่อีกครั้ง";

  // Analyze - No Data
  final String noDataTitle = "ยังไม่มีข้อมูลในช่วงเวลานี้";
  final String noDataDesc =
      "เพิ่มข้อมูลความดันโลหิตก่อน เพื่อให้ AI ช่วยวิเคราะห์ผลและสรุปให้คุณ";
}

class _SettingStrings {
  const _SettingStrings();

  // Recovery My Data - Scanner
  final String recoveryTitle = "กู้คืนข้อมูลของฉัน";
  final String uploadQRTitle = "อัปโหลด QR Code ของคุณ";
  final String uploadQRDescription =
      "กรุณาเลือกรูปภาพ QR Code\nที่คุณบันทึกไว้\nเพื่อกู้คืนข้อมูลบัญชีของคุณ";
  final String selectFromAlbum = "เลือกรูปภาพจากอัลบั้ม";
  final String openCameraScanner = "เปิดกล้องสแกน QR Code";

  // Recovery My Data - Errors
  final String qrNotFoundInImage = "ไม่พบ QR code ในรูปภาพนี้";
  final String decryptionFailed =
      "❌ ถอดรหัสล้มเหลว (อาจสแกน QR อื่นที่ไม่ใช่ของแอปเรา)";
  final String invalidQrData = "ไม่พบข้อมูล หรือ QR Code ไม่ถูกต้อง";
  final String imageProcessError = "เกิดข้อผิดพลาดในการประมวลผลรูปภาพ";
  final String qrProcessError = "เกิดข้อผิดพลาดในการประมวลผล QR Code";
  final String selfRecoveryError =
      "นี่คือข้อมูลของบัญชีปัจจุบันที่คุณกำลังใช้งานอยู่แล้ว";
  final String noInternetCannotFetch =
      "ไม่มีการเชื่อมต่ออินเทอร์เน็ต ไม่สามารถดึงข้อมูลบัญชีได้";
  final String accountNotFound = "ไม่พบข้อมูลบัญชีนี้ในระบบ";
  final String noInternetTryAgain =
      "ไม่มีการเชื่อมต่ออินเทอร์เน็ต กรุณาเชื่อมต่อแล้วลองใหม่";
  final String recoveryFailed = "กู้ข้อมูลล้มเหลว กรุณาลองใหม่อีกครั้ง";
  final String cannotResumeRecovery = "ไม่สามารถกู้ข้อมูลต่อได้";

  // Recovery My Data - Resume Error UI
  final String resumePausedTitle = "การกู้คืนข้อมูลหยุดชะงัก";
  final String resumePausedDesc =
      "กรุณาเชื่อมต่ออินเทอร์เน็ตแล้วกดลองใหม่เพื่อกู้ข้อมูลต่อ";
  final String retryResumeBtn = "ลองใหม่อีกครั้ง";

  // Recovery My Data - Progress / status
  final String fetchingFromServer = "กำลังดึงข้อมูลจากเซิร์ฟเวอร์...";
  String fetchSuccess(int length) => "ดึงข้อมูลสำเร็จ ($length รายการ)";
  final String preparingSpace = "กำลังเตรียมพื้นที่...";
  final String settingUpAccount = "กำลังตั้งค่าบัญชี...";
  final String savingProfile = "กำลังบันทึกโปรไฟล์...";
  String savingDataProgress(int saved, int total) =>
      "กำลังบันทึกข้อมูล ($saved/$total)...";
  final String clearingOldData = "กำลังล้างข้อมูลเก่า...";
  final String recoveryCompleted = "กู้ข้อมูลเรียบร้อยแล้ว! ✅";
  final String recoverySuccess = "กู้ข้อมูลเรียบร้อยแล้ว";

  // Recovery My Data - Preview UI
  final String accountFound = "พบข้อมูลบัญชีแล้ว !";
  final String readyToRecoverDesc =
      "ข้อมูลของคุณพร้อมกู้คืนแล้ว\nกรุณาตรวจสอบว่าอุปกรณ์เชื่อมต่ออินเทอร์เน็ต";
  final String confirmRecoveryBtn = "ยืนยันกู้ข้อมูล";

  // Recovery My Data - Dialog
  final String confirmRecoveryTitle = "ยืนยันการกู้ข้อมูล";
  final String confirmRecoveryWarning =
      "⚠️ กรุณาอ่านก่อนกดยืนยัน:\n\n• ต้องเชื่อมต่ออินเทอร์เน็ตตลอดการกู้ข้อมูล\n• ห้ามออกจากหน้านี้หรือปิดแอประหว่างกู้ข้อมูล\n• ข้อมูลเดิมในเครื่องนี้จะถูกแทนที่ด้วยข้อมูลที่กู้คืน";
  final String understandAndConfirm = "เข้าใจแล้ว ยืนยัน";
}

class _ResultStrings {
  const _ResultStrings();

  final String recordBloodPressure = "บันทึกความดัน";
}

class _CalendarStrings {
  const _CalendarStrings();

  final String day = "วัน";
  final String week = "สัปดาห์";
  final String month = "เดือน";
  final String year = "ปี";
  final String select = "เลือก";
  final String selectMonth = "เลือกเดือน";
  final String selectYear = "เลือกปี";
  final String selectPresentDay = "เลือกวันที่ปัจจุบัน";
  final String selectPresentWeek = "เลือกสัปดาห์ปัจจุบัน";
  final String selectPresentMonth = "เลือกเดือนปัจจุบัน";
  final String selectPresentYear = "เลือกปีปัจจุบัน";
  final String january = "มกราคม";
  final String february = "กุมภาพันธ์";
  final String march = "มีนาคม";
  final String april = "เมษายน";
  final String may = "พฤษภาคม";
  final String june = "มิถุนายน";
  final String july = "กรกฎาคม";
  final String august = "สิงหาคม";
  final String september = "กันยายน";
  final String october = "ตุลาคม";
  final String november = "พฤศจิกายน";
  final String december = "ธันวาคม";
}

class _BPGraphStrings {
  const _BPGraphStrings();

  String noDataFor(String type) => "ยังไม่มีข้อมูล$typeนี้";
  final recordToSeeTrend =
      "บันทึกค่าความดัน เพื่อดูสรุปสถิติและแนวโน้มสุขภาพของคุณ";
  final graphWillShowHere = "กราฟวิเคราะห์จะปรากฎที่นี่";
  final addRecordToday = "เพิ่มบันทึกวันนี้";
}
