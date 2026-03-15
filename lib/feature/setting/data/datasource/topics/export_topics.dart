import 'package:dun_diary_app/feature/setting/data/datasource/tutorial_data_source.dart';
import 'package:dun_diary_app/feature/setting/data/model/tutorial_content_block.dart';

List<TutorialStep> exportTopics = [
  TutorialStep(
    imagePath: 'assets/images/tutorial/export_step1.png',
    descriptionTitle: 'การส่งออกข้อมูล',
    blocks: [
      ParagraphBlock(
        text:
            'แตะไอคอน "3 จุด" ที่มุมขวาบน เพื่อเปิดเมนู\nสามารถเลือกส่งออกประวัติความดันของคุณเป็น\n"รูปภาพ" หรือไฟล์ "CSV"\nเพื่อนำไปเก็บไว้หรือส่งให้แพทย์ดูได้สะดวกยิ่งขึ้น',
      ),
    ],
  ),
  TutorialStep(
    imagePath: 'assets/images/tutorial/export_step1.png',
    descriptionTitle: 'การส่งออกเป็นไฟล์ CSV',
    blocks: [
      ParagraphBlock(
        text:
            'ระบุช่วงเวลาที่ต้องการโดยเลือกวันที่ "เริ่มจาก" และ "จนถึง" จากนั้นกดปุ่ม "ส่งออก" เพื่อรับไฟล์ข้อมูล CSV สำหรับนำไปเปิดดูในรูปแบบตาราง',
      ),
    ],
  ),
  TutorialStep(
    imagePath: 'assets/images/tutorial/export_step1.png',
    descriptionTitle: 'แชร์หรือบันทึกเป็นรูปภาพ',
    blocks: [
      ParagraphBlock(
        text:
            'เลือกว่าคุณต้องการ "บันทึกลงเครื่อง"\nเพื่อเซฟรูปภาพสรุปความดันเก็บไว้ หรือกดปุ่ม "แชร์"\nเพื่อส่งต่อรูปภาพให้ผู้อื่นผ่านแอปพลิเคชันต่างๆ',
      ),
    ],
  ),
];
