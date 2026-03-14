import 'package:dun_diary_app/feature/setting/data/datasource/tutorial_data_source.dart';
import 'package:dun_diary_app/feature/setting/data/model/tutorial_content_block.dart';

List<TutorialStep> recordTopics = [
  TutorialStep(
    imagePath: 'assets/images/tutorial/bp_step1.png',
    descriptionTitle: 'วิธีการบันทึกความดันประจำวัน',
    blocks: [
      PrefixBlock(
        prefix: 'วิธีที่ 1',
        text: 'แตะที่กล่องข้อความ "บันทึกความดัน" สีขาวที่อยู่ด้านบนของหน้าจอ',
      ),
      PrefixBlock(
        prefix: 'วิธีที่ 2',
        text: 'แตะที่ปุ่ม "➕" บริเวณกึ่งกลางของแถบเมนูด้านล่าง',
      ),
    ],
  ),
  TutorialStep(
    imagePath: 'assets/images/tutorial/bp_step2.png',
    descriptionTitle: 'การบันทึกความดันผ่านรูปถ่าย',
    blocks: [
      ParagraphBlock(text: 'แตะไอคอนกล้อง 📷 เพื่อเลือกวิธีสแกน'),
      NumberedBlock(
        number: 1,
        boldTitle: 'ถ่ายรูปผลวัด',
        text: 'ถ่ายหน้าจอเครื่องวัดความดัน',
      ),
      NumberedBlock(
        number: 2,
        boldTitle: 'เลือกรูปจากคลัง',
        text: 'เลือกรูปจากในมือถือของคุณ',
      ),
    ],
  ),
  TutorialStep(
    imagePath: 'assets/images/tutorial/bp_step3.png',
    descriptionTitle: 'การบันทึกความดันผ่านรูปถ่าย',
    blocks: [
      ParagraphBlock(text: 'ถ่ายรูปผลวัดความดันง่ายๆ'),
      NumberedBlock(
        number: 1,
        boldTitle: 'ถ่ายให้ชัด',
        text: 'ถ่ายหน้าจอไม่ให้เบลอ ไร้แสงสะท้อน เพื่อให้ AI อ่านค่าได้แม่นยำ',
      ),
      NumberedBlock(
        number: 2,
        boldTitle: 'ตรวจสอบและบันทึก',
        text: 'เช็คความถูกต้องของตัวเลข แล้วกดปุ่ม "บันทึก"',
      ),
    ],
  ),
];
