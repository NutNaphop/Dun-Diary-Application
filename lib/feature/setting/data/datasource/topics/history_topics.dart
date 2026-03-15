import 'package:dun_diary_app/feature/setting/data/datasource/tutorial_data_source.dart';
import 'package:dun_diary_app/feature/setting/data/model/tutorial_content_block.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';

List<TutorialStep> historyTopics = [
  TutorialStep(
    imagePath: TutorialImages.history.history1,
    descriptionTitle: 'ดูประวัติและกราฟรายวัน',
    blocks: [
      ParagraphBlock(
        text:
            'ปัดแถบวันที่ซ้าย-ขวาเพื่อเลือกดูประวัติ แอปจะแสดงค่าความดันล่าสุด ของวันนั้น พร้อม กราฟรายวัน ที่บอกรายละเอียดการบันทึกตลอดทั้งวันให้คุณดูแบบเข้าใจง่าย',
      ),
    ],
  ),
  TutorialStep(
    imagePath: TutorialImages.history.history2,
    descriptionTitle: 'ดูและแก้ไขข้อมูล',
    blocks: [
      ParagraphBlock(
        text:
            'เลื่อนหน้าจอลงเพื่อดูรายการบันทึกของวันนั้น\nและสามารถ "แตะที่รายการ"\nเพื่อเข้าไปแก้ไขค่าความดันได้ทันที',
      ),
    ],
  ),
  TutorialStep(
    imagePath: TutorialImages.history.history3,
    descriptionTitle: 'แก้ไขและลบข้อมูล',
    blocks: [
      BulletBlock(
        boldTitle: 'แก้ไขข้อมูล',
        text:
            'แตะปุ่ม "แก้ไข"\nเพื่อปรับเปลี่ยนค่าความดัน วันที่ หรือเวลาให้ถูกต้อง',
      ),
      BulletBlock(
        boldTitle: 'ลบข้อมูล',
        text: 'แตะปุ่ม "ลบ"\nหากต้องการลบรายการบันทึกทิ้ง',
      ),
    ],
  ),
];
