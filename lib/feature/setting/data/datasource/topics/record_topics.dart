import 'package:dun_diary_app/feature/setting/data/datasource/tutorial_data_source.dart';
import 'package:dun_diary_app/feature/setting/data/model/tutorial_content_block.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';

List<TutorialStep> recordTopics = [
  TutorialStep(
    imagePath: TutorialImages.record.record1,
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
    imagePath: TutorialImages.record.record2,
    descriptionTitle: 'การบันทึกค่าความดันด้วยตัวเอง',
    blocks: [
      NumberedBlock(
        number: 1,
        text: 'เลื่อนตัวเลขเพื่อระบุค่าความดัน (SYS, DIA) และชีพจร (PUL)',
      ),
      NumberedBlock(
        number: 2,
        text: 'แอปจะประเมินระดับความดันของคุณผ่านแถบสีให้ทันที',
      ),
      NumberedBlock(
        number: 3,
        text: 'ตรวจสอบวันที่และเวลา แล้วกดปุ่ม "บันทึก" ด้านล่างสุด',
      ),
    ],
  ),
  TutorialStep(
    imagePath: TutorialImages.record.record3,
    descriptionTitle: 'การบันทึกความดันผ่านรูปถ่าย',
    blocks: [
      ParagraphBlock(text: 'แตะไอคอนกล้อง 📷 เพื่อเลือกวิธีสแกน'),
      NumberedBlock(number: 1, text: 'ถ่ายรูปผลวัดถ่ายหน้าจอเครื่องวัดความดัน'),
      NumberedBlock(
        number: 2,
        text: 'เลือกรูปจากคลังเลือกรูปจากในมือถือของคุณ',
      ),
    ],
  ),
  TutorialStep(
    imagePath: TutorialImages.record.record4,
    descriptionTitle: 'การบันทึกความดันผ่านรูปถ่าย',
    blocks: [
      ParagraphBlock(text: 'ถ่ายรูปผลวัดความดันง่ายๆ'),
      NumberedBlock(
        number: 1,
        boldTitle: 'ถ่ายให้ชัด',
        text:
            'ถ่ายให้ชัด ถ่ายหน้าจอไม่ให้เบลอ ไร้แสงสะท้อน เพื่อให้ AI อ่านค่าได้แม่นยำ',
      ),
      NumberedBlock(
        number: 2,
        boldTitle: 'ตรวจสอบและบันทึก',
        text: 'ตรวจสอบและบันทึก เช็คความถูกต้องของตัวเลข แล้วกดปุ่ม "บันทึก"',
      ),
    ],
  ),
  TutorialStep(
    imagePath: TutorialImages.record.record5,
    descriptionTitle: 'การบันทึกโดยเลือกรูปจากอัลบั้ม',
    blocks: [
      ParagraphBlock(text: 'เลือกรูปภาพจากอัลบั้ม'),
      NumberedBlock(
        number: 1,
        text: 'เลือกรูป เลือกภาพหน้าจอเครื่องวัดที่คุณถ่ายเก็บไว้ ในมือถือ',
      ),
      NumberedBlock(
        number: 2,
        text: 'ตรวจสอบและบันทึก เช็คตัวเลขที่ระบบอ่านได้ แล้วกด "บันทึก"',
      ),
    ],
  ),
];
