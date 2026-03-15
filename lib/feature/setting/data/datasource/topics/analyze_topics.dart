import 'package:dun_diary_app/feature/setting/data/datasource/tutorial_data_source.dart';
import 'package:dun_diary_app/feature/setting/data/model/tutorial_content_block.dart';

List<TutorialStep> analyzeTopics = [
  TutorialStep(
    imagePath: 'assets/images/tutorial/analyze_step1.png',
    descriptionTitle: 'การวิเคราะห์ข้อมูล',
    blocks: [
      BulletBlock(
        text: 'ดูกราฟแนวโน้ม เลือกดูสถิติได้ทั้งรายสัปดาห์ เดือน หรือปี',
      ),
      BulletBlock(text: 'เช็คสุขภาพ ดูสรุปผลการประเมินความดันของคุณได้ทันที'),
    ],
  ),
  TutorialStep(
    imagePath: 'assets/images/tutorial/analyze_step2.png',
    descriptionTitle: 'สรุปผลและวิเคราะห์ด้วย AI',
    blocks: [
      BulletBlock(
        text:
            'สรุปภาพรวม ดูค่าเฉลี่ยความดันของคุณได้ทั้งแบบ รายสัปดาห์ เดือน หรือปี',
      ),
      BulletBlock(
        text:
            'AI ช่วยวิเคราะห์ กดปุ่มด้านล่างให้ AI ประเมินและ สรุปแนวโน้มสุขภาพของคุณแบบเจาะลึก',
      ),
    ],
  ),
];
