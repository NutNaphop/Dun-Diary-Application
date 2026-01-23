import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
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
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Blood Pressure Trends",
                      fontSize: Dimension.fontSizes.h2,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Modern Horizontal Filter Bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _FilterButton(
                      label: "รายชั่วโมง",
                      isSelected:
                          viewModel.selectedFilter == GraphFilterType.time,
                      onPressed: () =>
                          viewModel.setFilter(GraphFilterType.time),
                    ),
                    _FilterButton(
                      label: "7 วันล่าสุด",
                      isSelected:
                          viewModel.selectedFilter == GraphFilterType.day,
                      onPressed: () => viewModel.setFilter(GraphFilterType.day),
                    ),
                    _FilterButton(
                      label: "รายสัปดาห์",
                      isSelected:
                          viewModel.selectedFilter == GraphFilterType.week,
                      onPressed: () =>
                          viewModel.setFilter(GraphFilterType.week),
                    ),
                    _FilterButton(
                      label: "รายเดือน",
                      isSelected:
                          viewModel.selectedFilter == GraphFilterType.month,
                      onPressed: () =>
                          viewModel.setFilter(GraphFilterType.month),
                    ),
                    _FilterButton(
                      label: "ไม่มีข้อมูล",
                      isSelected:
                          viewModel.selectedFilter == GraphFilterType.empty,
                      onPressed: () =>
                          viewModel.setFilter(GraphFilterType.empty),
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
                    height: 320,
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 20, right: 10),
                    child: BpGraphSdk(
                      data: viewModel.currentData,
                      onPointTap: (select) {
                        print(select);
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _getCardTitle(GraphFilterType type) {
    switch (type) {
      case GraphFilterType.time:
        return "ข้อมูลรายชั่วโมง";
      case GraphFilterType.day:
        return "ข้อมูล 7 วันล่าสุด";
      case GraphFilterType.week:
        return "ข้อมูลรายสัปดาห์";
      case GraphFilterType.month:
        return "ข้อมูลรายเดือน (2568)";
      case GraphFilterType.empty:
        return "ไม่มีข้อมูล";
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
