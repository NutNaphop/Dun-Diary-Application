import 'package:dun_diary_app/feature/stat/model/stat_model.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/stat_card/stat_card.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';

class StatUiMappper {
  static List<StatCardData> mapToCardData(StatCalulatedType stats) {
    
    return [
      StatCardData(
        title: "ค่าเฉลี่ยความดัน",
        value: stats.avgBP,
        description: "อยู่ในเกณฑ์...", // อาจต้องเขียน logic เพิ่ม
        iconPath: AppIcons.duotone.heartPulse,
        background: CustomColor.pink1,
        foreground: CustomColor.pink2,
      ),
      StatCardData(
        iconPath: AppIcons.duotone.pulse,
        title: "การแกว่งตัว",
        value: stats.sd,
        description: "ระยะการแกว่งตัว",
        background: CustomColor.blue1,
        foreground: CustomColor.blue5,
      ),
      StatCardData(
        iconPath: AppIcons.duotone.graphUp,
        title: "ค่าสูงสุด",
        value: stats.maxBP,
        description: stats.maxBPDate != null 
            ? "เมื่อวันที่ ${DateTimeUtils.formatToThaiDate(stats.maxBPDate!)}"
            : "ไม่พบข้อมูล",
        background: CustomColor.red5,
        foreground: CustomColor.red4,
      ),
      StatCardData(
        iconPath: AppIcons.duotone.graphDown,
        title: "ค่าต่ำสุด",
        value: stats.minBP,
        description: stats.minBPDate != null 
            ? "เมื่อวันที่ ${DateTimeUtils.formatToThaiDate(stats.minBPDate!)}"
            : "ไม่พบข้อมูล",
        background: CustomColor.purple3,
        foreground: CustomColor.purple2,
      ),
    ];
  }
}
