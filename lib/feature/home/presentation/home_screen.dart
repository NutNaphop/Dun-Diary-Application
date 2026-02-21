import 'package:dun_diary_app/core/auth/provider/global_user_provider.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/feature/home/presentation/home_viewModel.dart';
import 'package:dun_diary_app/feature/home/presentation/widgets/card/home_bp_card.dart';
import 'package:dun_diary_app/feature/home/presentation/widgets/home_header.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/no_content_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/stat_row.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) =>
          HomeViewmodel(recordRepo: context.read<BloodPressureRepository>()),
      child: const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hasRecords = context.select((HomeViewmodel vm) => vm.hasRecords);
    final latestRecord = context.select((HomeViewmodel vm) => vm.latestRecord);

    final userName = context.select((GlobalUserProvider p) => p.displayName);

    return CustomScaffold(
      useSafeArea: false,
      usePadding: false,
      body: Column(
        children: [
          HomeHeader(userName: userName),
          const SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  spacing: 25,
                  children: [
                    // --- ส่วนการ์ดแสดงผลสุขภาพ (Health Status Card) ---
                    CustomCard(
                      title: AppStrings.home.healthToday,
                      contentPadding: const EdgeInsets.all(20),
                      content: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (hasRecords) ...[
                            StatRow(
                              leading: SVGImage(
                                path: AppIcons.duotone.graphUp,
                                width: 34,
                                height: 34,
                                color: CustomColor.purple1,
                              ),
                              label: AppStrings.bloodPressure.sysShortLabel,
                              description: AppStrings.bloodPressure.sysDesc,
                              value: latestRecord?.sys.toString() ?? '-',
                            ),
                            StatRow(
                              leading: SVGImage(
                                path: AppIcons.duotone.graphDown,
                                width: 34,
                                height: 34,
                                color: CustomColor.blue4,
                              ),
                              label: AppStrings.bloodPressure.diaShortLabel,
                              description: AppStrings.bloodPressure.diaDesc,
                              value: latestRecord?.dia.toString() ?? '-',
                            ),
                            StatRow(
                              leading: SVGImage(
                                path: AppIcons.duotone.heartPulse,
                                width: 34,
                                height: 34,
                                color: CustomColor.pink3,
                              ),
                              label: AppStrings.bloodPressure.pulseShortLabel,
                              description: AppStrings.bloodPressure.pulseDesc,
                              value: latestRecord?.pulse.toString() ?? '-',
                            ),
                          ] else ...[
                            NoContentCard(
                              title: AppStrings.home.noContent,
                              subtitle: AppStrings.home.pressToRecord,
                              imagePath: AppImages.emptyFolder,
                              imageWidth: 106,
                              imageHeight: 117,
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Blood Pressure Card
                    HomeBpCard(),
                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
