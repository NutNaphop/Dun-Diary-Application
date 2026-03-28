import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/bp_graph_playground_viewmodel.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/bp_graph_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BpGraphPlayground extends StatelessWidget {
  const BpGraphPlayground({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BpGraphPlaygroundViewModel(),
      child: const _BpGraphPlaygroundView(),
    );
  }
}

class _BpGraphPlaygroundView extends StatelessWidget {
  const _BpGraphPlaygroundView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<BpGraphPlaygroundViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // สีพื้นหลังที่ดูนุ่มนวลขึ้น
      appBar: AppBar(
        title: const CustomText(
          text: 'GraphSDK Playground',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: CustomColor.accentColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () => viewModel.replayAnimation(),
            tooltip: 'เล่นแอนิเมชันใหม่',
          ),
        ],
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Modern Horizontal Filter Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _FilterButton(
                    label: "รายชั่วโมง (มี)",
                    isSelected:
                        viewModel.selectedFilter == GraphFilterType.time,
                    onPressed: () => viewModel.setFilter(GraphFilterType.time),
                  ),
                  _FilterButton(
                    label: "สัปดาห์ (มี)",
                    isSelected:
                        viewModel.selectedFilter == GraphFilterType.week,
                    onPressed: () => viewModel.setFilter(GraphFilterType.week),
                  ),
                  _FilterButton(
                    label: "เดือน (มี)",
                    isSelected:
                        viewModel.selectedFilter == GraphFilterType.month,
                    onPressed: () => viewModel.setFilter(GraphFilterType.month),
                  ),
                  _FilterButton(
                    label: "ปี (มี)",
                    isSelected:
                        viewModel.selectedFilter == GraphFilterType.year,
                    onPressed: () => viewModel.setFilter(GraphFilterType.year),
                  ),
                  _FilterButton(
                    label: "ไม่มีข้อมูล",
                    isSelected:
                        viewModel.selectedFilter == GraphFilterType.empty,
                    onPressed: () => viewModel.setFilter(GraphFilterType.empty),
                  ),
                  _FilterButton(
                    label: "สัปดาห์ (ว่าง)",
                    isSelected:
                        viewModel.selectedFilter == GraphFilterType.emptyWeek,
                    onPressed: () =>
                        viewModel.setFilter(GraphFilterType.emptyWeek),
                  ),
                  _FilterButton(
                    label: "เดือน (ว่าง)",
                    isSelected:
                        viewModel.selectedFilter == GraphFilterType.emptyMonth,
                    onPressed: () =>
                        viewModel.setFilter(GraphFilterType.emptyMonth),
                  ),
                  _FilterButton(
                    label: "ปี (ว่าง)",
                    isSelected:
                        viewModel.selectedFilter == GraphFilterType.emptyYear,
                    onPressed: () =>
                        viewModel.setFilter(GraphFilterType.emptyYear),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Graph Card Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomCard(
                title: _getCardTitle(viewModel.selectedFilter),
                contentPadding: const EdgeInsets.all(20),
                content: Container(
                  height: 350,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 20, right: 10),
                  child: BpGraphSdk(
                    key: ValueKey(viewModel.refreshCounter),
                    heading: viewModel.selectedFilter.label,
                    data: viewModel.currentData,
                    onPointTap: (select) {
                      AppLogger.debug(
                        "${select.xLabel} : ${select.level.label}}",
                      );
                    },
                    onButtonPress: viewModel.navigationToRecord,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String? _getCardTitle(GraphFilterType type) {
    switch (type) {
      case GraphFilterType.time:
        return "ข้อมูลรายชั่วโมง";
      case GraphFilterType.week:
        return "วันที่ 1 ถึง 7 มกราคม 2568";
      case GraphFilterType.month:
        return "มกราคม 2568";
      case GraphFilterType.year:
        return "2568";
      case GraphFilterType.empty:
        return null;
      case GraphFilterType.emptyWeek:
        return null;
      case GraphFilterType.emptyMonth:
        return null;
      case GraphFilterType.emptyYear:
        return null;
    }
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ChoiceChip(
          label: CustomText(
            text: label,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : CustomColor.gray600,
          ),
          selected: isSelected,
          onSelected: (_) => onPressed(),
          selectedColor: CustomColor.primaryColor,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? Colors.transparent : CustomColor.gray200,
            ),
          ),
          elevation: isSelected ? 4 : 0,
          pressElevation: 0,
        ),
      ),
    );
  }
}
