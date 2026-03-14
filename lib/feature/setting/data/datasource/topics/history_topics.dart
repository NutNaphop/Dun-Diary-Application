import 'package:dun_diary_app/feature/setting/data/datasource/tutorial_data_source.dart';
import 'package:dun_diary_app/feature/setting/data/model/tutorial_content_block.dart';

List<TutorialStep> historyTopics = [
  TutorialStep(
    imagePath: 'assets/images/tutorial/history_step1.png',
    descriptionTitle: 'ดูประวัติและกราฟรายวัน',
    blocks: [
      ParagraphBlock(
        text:
            'ปัดแถบวันที่ซ้าย-ขวาเพื่อเลือกดูประวัติ แอปจะแสดงค่าความดันล่าสุด ของวันนั้น พร้อม กราฟรายวัน ที่บอกรายละเอียดการบันทึกตลอดทั้งวันให้คุณดูแบบเข้าใจง่าย',
      ),
    ],
  ),
  TutorialStep(
    imagePath: 'assets/images/tutorial/history_step2.png',
    descriptionTitle: 'ดูและแก้ไขข้อมูล',
    blocks: [
      ParagraphBlock(
        text:
            'เลื่อนหน้าจอลงเพื่อดูรายการบันทึกของวันนั้น และสามารถ "แตะที่รายการ" เพื่อเข้าไปแก้ไขค่าความดันได้ทันที',
      ),
    ],
  ),
  TutorialStep(
    imagePath: 'assets/images/tutorial/history_step3.png',
    descriptionTitle: 'แก้ไขและลบข้อมูล',
    blocks: [
      BulletBlock(
        boldTitle: 'แก้ไขข้อมูล',
        text:
            'แตะปุ่ม "แก้ไข" เพื่อปรับเปลี่ยนค่าความดัน วันที่ หรือเวลาให้ถูกต้อง',
      ),
      BulletBlock(
        boldTitle: 'ลบข้อมูล',
        text: 'แตะปุ่ม "ลบ" หากต้องการลบรายการบันทึกทิ้ง',
      ),
    ],
  ),
];
