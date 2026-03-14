import 'package:dun_diary_app/feature/setting/data/datasource/tutorial_data_source.dart';
import 'package:dun_diary_app/feature/setting/data/model/tutorial_content_block.dart';

List<TutorialStep> recoveryTopics = [
  TutorialStep(
    imagePath: 'assets/images/tutorial/recovery_step1.png',
    descriptionTitle: 'การกู้คืนข้อมูล',
    blocks: [
      BulletBlock(
        boldTitle: 'กู้คืนข้อมูล',
        text: 'เลือกกู้คืนข้อมูลได้ทั้งแบบรายสัปดาห์ เดือน หรือปี',
      ),
    ],
  ),
];
