enum TutorialTopic {
  recordBloodPressure,
  analyzeData,
  history,
  recoveryData,
  exportData;

  String get title {
    switch (this) {
      case TutorialTopic.recordBloodPressure:
        return 'วิธีการบันทึกความดัน';
      case TutorialTopic.analyzeData:
        return 'การวิเคราะห์ข้อมูล';
      case TutorialTopic.history:
        return 'การดูประวัติย้อนหลัง';
      case TutorialTopic.recoveryData:
        return 'การสำรองและกู้คืนข้อมูล';
      case TutorialTopic.exportData:
        return 'การส่งออกข้อมูล';
    }
  }
}
