import 'package:dun_diary_app/feature/setting/data/model/tutorial_topic.dart';

class TutorialStep {
  final String imagePath;
  final String descriptionTitle;
  final List<String> instructions;

  TutorialStep({
    required this.imagePath,
    required this.descriptionTitle,
    required this.instructions,
  });
}

class TutorialDataSource {
  static List<TutorialStep> getStepsForTopic(TutorialTopic topic) {
    switch (topic) {
      case TutorialTopic.recordBloodPressure:
        return [
          TutorialStep(
            imagePath:
                'assets/images/tutorial/bp_step1.png', // จำเป็นต้องแก้ไข path หรือลบถ้าไม่มี
            descriptionTitle: 'วิธีการบันทึกความดันประจำวัน',
            instructions: [
              'วิธีที่ 1: แตะที่บรรทัดข้อความ "บันทึกความดัน" สีขาวที่อยู่ด้านบนของหน้าจอ',
              'วิธีที่ 2: แตะที่ปุ่ม "+" บริเวณกึ่งกลางของแถบเมนูด้านล่าง',
            ],
          ),
          TutorialStep(
            imagePath:
                'assets/images/tutorial/bp_step1.png', // จำเป็นต้องแก้ไข path หรือลบถ้าไม่มี
            descriptionTitle: 'วิธีการบันทึกความดันประจำวัน',
            instructions: [
              'วิธีที่ 1: แตะที่บรรทัดข้อความ "บันทึกความดัน" สีขาวที่อยู่ด้านบนของหน้าจอ',
              'วิธีที่ 2: แตะที่ปุ่ม "+" บริเวณกึ่งกลางของแถบเมนูด้านล่าง',
            ],
          ),
          TutorialStep(
            imagePath:
                'assets/images/tutorial/bp_step1.png', // จำเป็นต้องแก้ไข path หรือลบถ้าไม่มี
            descriptionTitle: 'วิธีการบันทึกความดันประจำวัน',
            instructions: [
              'วิธีที่ 1: แตะที่บรรทัดข้อความ "บันทึกความดัน" สีขาวที่อยู่ด้านบนของหน้าจอ',
              'วิธีที่ 2: แตะที่ปุ่ม "+" บริเวณกึ่งกลางของแถบเมนูด้านล่าง',
            ],
          ),
          // เพิ่ม Step อื่นๆ ตรงนี้
        ];
      case TutorialTopic.analyzeData:
        return [];
      case TutorialTopic.history:
        return [];
      case TutorialTopic.recoveryData:
        return [];
      case TutorialTopic.exportData:
        return [];
    }
  }
}
