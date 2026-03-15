import 'package:dun_diary_app/feature/setting/data/datasource/tutorial_data_source.dart';
import 'package:dun_diary_app/feature/setting/data/model/tutorial_content_block.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';

List<TutorialStep> recoveryTopics = [
  TutorialStep(
    imagePath: TutorialImages.recovery.recovery1,
    descriptionTitle: 'การสำรองและกู้คืนข้อมูล',
    blocks: [
      ParagraphBlock(
        text:
            'แตะเลือกเมนู "การสำรองข้อมูลและกู้ข้อมูล" เพื่อบันทึก\nประวัติความดันของคุณเก็บไว้ สำหรับใช้กู้คืนข้อมูลเมื่อ\nต้องการย้ายไปใช้งานบนโทรศัพท์เครื่องอื่น',
      ),
    ],
  ),
  TutorialStep(
    imagePath: TutorialImages.recovery.recovery2,
    descriptionTitle: 'การสำรองและกู้คืนข้อมูล',
    blocks: [
      BulletBlock(
        boldTitle: 'QR Code ของฉัน',
        text: 'กดเพื่อสำรองข้อมูลและบันทึก รูปคิวอาร์โค้ด',
      ),
      BulletBlock(
        boldTitle: 'กู้คืนข้อมูลของฉัน',
        text: 'กดเพื่อดึงข้อมูลประวัติเดิมกลับ มาเมื่อเปลี่ยนเครื่องใหม่',
      ),
    ],
  ),
  TutorialStep(
    imagePath: TutorialImages.recovery.recovery3,
    descriptionTitle: 'บันทึก QR Code ของคุณ',
    blocks: [
      ParagraphBlock(
        text:
            'แตะปุ่ม "บันทึกรูปภาพ"\nเพื่อดาวน์โหลดรหัสเก็บไว้ให้ปลอดภัย\nสำหรับใช้สแกนเพื่อกู้คืนข้อมูลของคุณในอนาคต',
      ),
    ],
  ),
  TutorialStep(
    imagePath: TutorialImages.recovery.recovery4,
    descriptionTitle: 'วิธีกู้คืนข้อมูลด้วย QR Code',
    blocks: [
      BulletBlock(
        boldTitle: 'เลือกรูปจากอัลบั้ม',
        text: 'อัปโหลดรูปคิวอาร์โค้ดที่คุณเคยเซฟเก็บไว้ในเครื่อง',
      ),
      BulletBlock(
        boldTitle: 'เปิดกล้องสแกน',
        text:
            'ใช้กล้องสแกนคิวอาร์โค้ดจากหน้าจอมือถืออีกเครื่อง เพื่อดึงข้อมูลกลับมา',
      ),
    ],
  ),
  TutorialStep(
    imagePath: TutorialImages.recovery.recovery5,
    descriptionTitle: 'พบข้อมูลและพร้อมกู้คืน',
    blocks: [
      BulletBlock(
        boldTitle: 'ตรวจสอบบัญชี',
        text: 'เช็คชื่อและโปรไฟล์บนหน้าจอว่าถูกต้องตรงกับบัญชีของคุณ',
      ),
      BulletBlock(
        boldTitle: 'กู้คืนข้อมูล',
        text:
            'กดปุ่ม "กู้ข้อมูล" ด้านล่างสุด เพื่อดึง ประวัติทั้งหมดกลับมา\n(ต้องเชื่อมต่ออินเทอร์เน็ตไว้ตลอดการกู้ข้อมูล)',
      ),
    ],
  ),
];
