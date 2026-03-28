import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/feature/home/presentation/home_viewModel.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_lottie_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeBpCard extends StatelessWidget {
  const HomeBpCard({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HomeViewmodel>();
    final latestRecord = viewModel.latestRecord;

    if (latestRecord == null) {
      return const SizedBox.shrink();
    }

    final BPRecord(:sys, :dia, :pulse, :createdAt) = latestRecord;
    final level = BloodPressureUtils.calculateBloodPressureLevel(sys, dia);

    return Column(
      spacing: 15,
      children: [
        CustomCard(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LottieAnimation(path: level.animation, width: 62, height: 62),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: AppStrings.bloodPressure.bloodPressure(level.label),
                      fontSize: Dimension.fontSizes.xl,
                      fontWeight: Dimension.fontWeights.bold,
                      color: level.color,
                    ),
                    SizedBox(height: 10),
                    CustomText(
                      text: level.description,
                      fontSize: Dimension.fontSizes.md,
                      fontWeight: Dimension.fontWeights.medium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
