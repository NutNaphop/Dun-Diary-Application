import 'package:dun_diary_app/feature/record/data/model/record_model.dart';

class BloodPressureUtils {
  static BloodPressure parseStringToBloodPressure(String sys, String dia, String pul) {
    final parseSys = int.tryParse(sys) ?? 0;
    final parseDia = int.tryParse(dia) ?? 0;
    final parsePul = int.tryParse(pul) ?? 0;


    return BloodPressure(sys: parseSys, dia: parseDia, pul: parsePul);
  }
  static BloodPressure parseIntToBloodPressure(int sys, int dia, int pul) {
    return BloodPressure(sys: sys, dia: dia, pul: pul);
  }

  static int calculateBloodPressureLevel(int sys, int dia) {
    int sysLevel = 0;
    int diaLevel = 0;
    int bpLevel = 0;

    if (sys >= 160) {
      sysLevel = 4;
    } else if (sys > 140) {
      sysLevel = 3;
    } else if (sys > 130) {
      sysLevel = 2;
    } else if (sys <= 130 && sys >= 90) {
      sysLevel = 1;
    } else {
      sysLevel = 0;
    }

    if (dia >= 100) {
      diaLevel = 4;
    } else if (dia > 90) {
      diaLevel = 3;
    } else if (dia > 80) {
      diaLevel = 2;
    } else if (dia <= 80 && dia >= 60) {
      diaLevel = 1;
    } else {
      diaLevel = 0;
    }

    if (sysLevel >= 2 || diaLevel >= 2) {
      bpLevel = sysLevel > diaLevel ? sysLevel : diaLevel;
    } else if (sysLevel == 0 || diaLevel == 0) {
      bpLevel = 0;
    } else {
      bpLevel = 1;
    }

    return bpLevel;
  }

  static String mapLevelLabel(int level) {
    switch (level) {
      case 0:
        return "ต่ำ";

      case 1:
        return "ปกติ";

      case 2:
        return "เริ่มสูง";

      case 3:
        return "สูง";

      default:
        return "อันตราย";
    }
  }

  static double calculateAVGSYS(List<int> sysList) {
    int sumSys = sysList.fold(
      0,
      (previousValue, element) => previousValue + element,
    );
    return (sumSys) / sysList.length;
  }

  static double calculateAVGDIA(List<int> diaList) {
    int sumDia = diaList.fold(
      0,
      (previousValue, element) => previousValue + element,
    );
    return (sumDia) / diaList.length;
  }

  static double calculateAVGPUL(List<int> pulList) {
    int sumPul = pulList.fold(
      0,
      (previousValue, element) => previousValue + element,
    );
    return (sumPul) / pulList.length;
  }

  static int calculateAVGLevel(List<int> levelList) {
    int sumLevel = levelList.fold(
      0,
      (previousValue, element) => previousValue + element,
    );
    return (sumLevel / levelList.length).round();
  }
}
