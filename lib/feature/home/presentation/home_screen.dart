import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/feature/home/presentation/home_viewModel.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/no_content_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/stat_row.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:dun_diary_app/shared/widgets/custom/svg/custom_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => HomeViewmodel(
        recordRepo: context.read<BloodPressureRepository>(),
        networkInfo: context.read<NetworkInfo>(),
        authService: context.read<AuthService>(),
      ),
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
    final viewModel = context.read<HomeViewmodel>(); // เอาไว้กดปุ่ม

    return CustomScaffold(
      appBar: MainAppBar(
        isHome: true,
        title: "คุณเอกพจน์",
        actions: [
          IconButtonSVG(
            path: AppIcons.fill.notification,
            size: 32,
            onPressed: () {
              // viewModel.toggleHasRecord();
              // viewModel.showFlushbar(context);
              viewModel.deleteLocalData();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          spacing: 25,
          children: [
            // --- ส่วนปุ่ม (Button) ---
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: CustomButton(
                    text: AppStrings.home.startRecord,
                    textStyle: TextStyle(
                      color: CustomColor.gray900,
                      fontSize: Dimension.fontSizes.h2,
                      fontWeight: Dimension.fontWeights.regular,
                    ),
                    leadingIcon: SVGImage(
                      path: AppIcons.duotone.pulse,
                      size: 45,
                      color: CustomColor.primaryColor,
                    ),
                    trailingIcon: SVGImage(
                      path: AppIcons.duotone.addCircle,
                      size: 28,
                      color: CustomColor.primaryColor,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    boxShadow: [DropShadow.drop_thumb],
                    onPressed: () {
                      viewModel.redirectToRecord();
                    },
                  ),
                ),
              ],
            ),

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
                        size: 34,
                        color: CustomColor.purple1,
                      ),
                      label: AppStrings.bloodPressure.sysShortLabel,
                      description: AppStrings.bloodPressure.sysDesc,
                      value: latestRecord?.sys.toString() ?? '-',
                    ),
                    StatRow(
                      leading: SVGImage(
                        path: AppIcons.duotone.graphDown,
                        size: 34,
                        color: CustomColor.blue1,
                      ),
                      label: AppStrings.bloodPressure.diaShortLabel,
                      description: AppStrings.bloodPressure.diaDesc,
                      value: latestRecord?.dia.toString() ?? '-',
                    ),
                    StatRow(
                      leading: SVGImage(
                        path: AppIcons.duotone.heartPulse,
                        size: 34,
                        color: CustomColor.pink1,
                      ),
                      label: AppStrings.bloodPressure.pulseShortLabel,
                      description: AppStrings.bloodPressure.pulseDesc,
                      value: latestRecord?.pulse.toString() ?? '-',
                    ),
                  ] else ...[
                    NoContentCard(
                      title: AppStrings.home.noContent,
                      subtitle: AppStrings.home.recordTodayTogether,
                      imagePath: AppImage.cuate,
                      imageSize: 80,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
