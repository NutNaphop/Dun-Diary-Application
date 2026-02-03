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
  static const record = _RecordStrings();
  static const result = _ResultStrings();
  static const stat = _StatStrings();
}

class _CommonStrings {
  const _CommonStrings();

  final String appName = "Dun Diary";
  final String welcomeMessage = "Welcome to Dun Diary";
  final String greeting = "สวัสดี";

  final date = "วันที่";
  final time = "เวลา";

  final String error = "เกิดข้อผิดพลาด";
  final String noContentFound = "ไม่พบเนื้อหา";

  final String tryAgain = "ลองอีกครั้ง";
  final String loading = "กำลังโหลด...";

  final String saved = "บันทึกแล้ว";
  final String saving = "กำลังบันทึก...";
  final String save = "บันทึก";

  final String cancel = "ยกเลิก";
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

  final String low = "ต่ำ";
  final String normal = "ปกติ";
  final String preHigh = "เริ่มสูง";
  final String high = "สูง";
  final String danger = "อันตราย";
}

class _MainStrings {
  const _MainStrings();

  final String addPage = "หน้าเพิ่ม";
  final String statPage = "หน้าสถิติ";
  final String profilePage = "หน้าโปรไฟล์";
}

class _HomeStrings {
  const _HomeStrings();

  String greeting(String name) => "สวัสดี, $name";
  final String startRecord = "เริ่มบันทึกความดันโลหิต";
  final String healthToday = "สุขภาพของคุณวันนี้";
  final String noContent = "ยังไม่มีข้อมูลความดันโลหิต";
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
}

class _StatStrings {
  const _StatStrings();

  final String stat = "สถิติ";
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
