import 'package:dun_diary_app/feature/stat/model/stat_model.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/stat_card/stat_card.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';

class StatUiMappper {
  static List<StatCardData> mapToCardData(
    StatCalulatedType stats,
    int? bloodPressureLevel,
  ) {
    return [
      StatCardData(
        title: AppStrings.stat.avgBP,
        value: stats.avgBP,
        description: bloodPressureLevel != null
            ? BloodPressureUtils.mapLevelLabel(bloodPressureLevel)
            : AppStrings.stat.noData,
        iconPath: AppIcons.duotone.heartPulse,
        background: CustomColor.pink1,
        foreground: CustomColor.pink2,
      ),
      StatCardData(
        iconPath: AppIcons.duotone.pulse,
        title: AppStrings.stat.fluctuation,
        value: stats.sd,
        description: AppStrings.stat.fluctuationRange,
        background: CustomColor.blue1,
        foreground: CustomColor.blue5,
      ),
      StatCardData(
        iconPath: AppIcons.duotone.graphUp,
        title: AppStrings.stat.maxBP,
        value: stats.maxBP,
        description: stats.maxBPDate != null
            ? AppStrings.stat.recordedOn(
                DateTimeUtils.formatToThaiDate(stats.maxBPDate!),
              )
            : AppStrings.stat.noDataFound,
        background: CustomColor.red5,
        foreground: CustomColor.red4,
      ),
      StatCardData(
        iconPath: AppIcons.duotone.graphDown,
        title: AppStrings.stat.minBP,
        value: stats.minBP,
        description: stats.minBPDate != null
            ? AppStrings.stat.recordedOn(
                DateTimeUtils.formatToThaiDate(stats.minBPDate!),
              )
            : AppStrings.stat.noDataFound,
        background: CustomColor.purple3,
        foreground: CustomColor.purple2,
      ),
    ];
  }
}
