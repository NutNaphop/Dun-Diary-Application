import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/feature/history/presentation/history_viewmodel.dart';
import 'package:dun_diary_app/feature/history/presentation/widgets/history_graph_card.dart';
import 'package:dun_diary_app/feature/history/presentation/widgets/history_summary_card.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/sheet/custom_bottom_sheet.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPicExportSheet extends StatelessWidget {
  final DateTime selectedDate;
  const HistoryPicExportSheet({super.key, required this.selectedDate});

  static void show(BuildContext context) {
    final vm = context.read<HistoryViewmodel>();
    CustomBottomSheet.show(
      context: context,
      padding: EdgeInsets.zero,
      height: MediaQuery.of(context).size.height * 0.9,
      child: ChangeNotifierProvider.value(
        value: vm,
        child: HistoryPicExportSheet(selectedDate: vm.selectedDate),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: 20),
              // Header
              Row(
                children: [
                  CustomText(
                    text: "Dun Diary",
                    fontSize: Dimension.fontSizes.h1,
                    fontWeight: Dimension.fontWeights.bold,
                  ),
                  const Spacer(),
                  CustomText(
                    text: DateTimeUtils.formatToThaiDate(selectedDate),
                    fontSize: Dimension.fontSizes.md,
                    fontWeight: Dimension.fontWeights.semiBold,
                  ),
                ],
              ),
              // Guage
              SizedBox(height: 20),
              HistorySummaryCard(),

              // Graph
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(boxShadow: [DropShadow.drop_thumb]),
                child: HistoryGraphCard(),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Divider(color: CustomColor.gray300, thickness: 1),
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 42),
          child: Column(
            children: [
              GestureDetector(
                onTap: NavigationService.instance.goBack,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: CustomColor.gray100, width: 1),
                    color: CustomColor.white,
                  ),
                  child: SVGImage(
                    path: AppIcons.outline.fileDownload,
                    width: 24,
                    height: 24,
                    color: CustomColor.gray900,
                  ),
                ),
              ),
              CustomText(
                text: "ดาวน์โหลด",
                fontSize: Dimension.fontSizes.md,
                fontWeight: Dimension.fontWeights.regular,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
