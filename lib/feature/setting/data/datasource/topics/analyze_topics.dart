import 'package:dun_diary_app/feature/setting/data/datasource/tutorial_data_source.dart';
import 'package:dun_diary_app/feature/setting/data/model/tutorial_content_block.dart';

List<TutorialStep> analyzeTopics = [
  TutorialStep(
    imagePath: 'assets/images/tutorial/analyze_step1.png',
    descriptionTitle: 'การวิเคราะห์ข้อมูล',
    blocks: [
      BulletBlock(
        boldTitle: 'ดูกราฟแนวโน้ม',
        text: 'เลือกดูสถิติได้ทั้งรายสัปดาห์ เดือน หรือปี',
      ),
      BulletBlock(
        boldTitle: 'เช็คสุขภาพ',
        text: 'ดูสรุปผลการประเมินความดันของคุณได้ทันที',
      ),
    ],
  ),
  TutorialStep(
    imagePath: 'assets/images/tutorial/analyze_step2.png',
    descriptionTitle: 'สรุปผลและวิเคราะห์ด้วย AI',
    blocks: [
      BulletBlock(
        boldTitle: 'สรุปภาพรวม',
        text: 'ดูค่าเฉลี่ยความดันของคุณได้ทั้งแบบรายสัปดาห์ เดือน หรือปี',
      ),
      BulletBlock(
        boldTitle: 'AI ช่วยวิเคราะห์',
        text:
            'กดปุ่มด้านล่างให้ AI ประเมินและสรุปแนวโน้มสุขภาพของคุณแบบเจาะลึก',
      ),
    ],
  ),
];
