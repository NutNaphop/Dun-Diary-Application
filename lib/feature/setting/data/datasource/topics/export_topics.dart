import 'package:dun_diary_app/feature/setting/data/datasource/tutorial_data_source.dart';
import 'package:dun_diary_app/feature/setting/data/model/tutorial_content_block.dart';

List<TutorialStep> exportTopics = [
  TutorialStep(
    imagePath: 'assets/images/tutorial/export_step1.png',
    descriptionTitle: 'การส่งออกข้อมูล',
    blocks: [
      BulletBlock(
        boldTitle: 'ส่งออกข้อมูล',
        text: 'เลือกส่งออกข้อมูลได้ทั้งแบบรายสัปดาห์ เดือน หรือปี',
      ),
    ],
  ),
];
