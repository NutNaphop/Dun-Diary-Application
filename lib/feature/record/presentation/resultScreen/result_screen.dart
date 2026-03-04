import 'dart:io';

import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/feature/record/presentation/resultScreen/result_viewModel.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/stat_row.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:dun_diary_app/shared/widgets/ui/image/image_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  final File? image;

  const ResultScreen({super.key, this.image});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => ResultViewmodel(),
      child: const ResultScreen(),
    );
  }

  static Widget createWithArg(File image) {
    return ChangeNotifierProvider(
      create: (context) => ResultViewmodel(),
      child: ResultScreen(image: image),
    );
  }

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.image != null) {
      final image = widget.image!;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        context.read<ResultViewmodel>().setSelectImage(image);
        context.read<ResultViewmodel>().sendImageToModel(image);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResultViewmodel>();

    return CustomScaffold(
      appBar: MainAppBar(
        title: AppStrings.result.recordBloodPressure,
        showBack: true,
        onBackPressed: () => NavigationService.instance.goBack(),
      ),
      body: !viewModel.isAnalysisCompleted
          ? Center(child: ImageDisplay(image: null))
          : Container(
              padding: EdgeInsets.only(top: 33, bottom: 30),
              child: Column(
                spacing: 21,
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: FileImage(viewModel.selectedImage!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  CustomCard(
                    title: AppStrings.result.bloodPressureResult,
                    titleFontWeight: Dimension.fontWeights.medium,
                    titleFontSize: Dimension.fontSizes.h2,
                    contentPadding: EdgeInsets.all(10),
                    content: Column(
                      children: [
                        StatRow(
                          leading: SVGImage(
                            path: AppIcons.duotone.graphUp,
                            width: 34,
                            height: 34,
                            color: CustomColor.purple1,
                          ),
                          label: AppStrings.bloodPressure.sysShortLabel,
                          description: AppStrings.bloodPressure.sysDesc,
                          value: viewModel.sysValue,
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
                          value: viewModel.diaValue,
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
                          value: viewModel.pulValue,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 22,
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: AppStrings.common.cancel,
                          type: CustomButtonType.outline,
                          boxShadow: [DropShadow.drop_thumb],
                          borderColor: CustomColor.gray400,
                          onPressed: () {
                            NavigationService.instance.goBack();
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomButton(
                          type: CustomButtonType.fill,
                          boxShadow: [DropShadow.drop_thumb],
                          text: AppStrings.common.save,
                          onPressed: () {
                            viewModel.submitRecord();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
