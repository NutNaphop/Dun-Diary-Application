import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/components/calendar_base_cell.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/utils/calendar_utils.dart';
import 'package:flutter/material.dart';

class YearPickerView extends StatefulWidget {
  final int selectedYear;
  final int startYear;
  final int endYear;
  final Function(int) onYearSelected;

  const YearPickerView({
    super.key,
    required this.selectedYear,
    required this.startYear,
    required this.endYear,
    required this.onYearSelected,
  });

  @override
  State<YearPickerView> createState() => _YearPickerViewState();
}

class _YearPickerViewState extends State<YearPickerView> {
  late PageController _pageController;
  final int yearsPerPage = 12;

  @override
  void initState() {
    super.initState();

    final int selectedIndex = widget.selectedYear - widget.startYear;
    final int safeIndex = selectedIndex < 0 ? 0 : selectedIndex;
    final int initialPage = (safeIndex / yearsPerPage).floor();
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int currentYear = DateTime.now().year;
    final int totalYears = widget.endYear - widget.startYear + 1;
    final int totalPages = (totalYears / yearsPerPage).ceil();

    return Column(
      mainAxisSize: MainAxisSize.min, // ให้ Column หดตัวเท่าเนื้อหา
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: totalPages,
            itemBuilder: (context, pageIndex) {
              final int startIndex = pageIndex * yearsPerPage;
              final int remainingItems = totalYears - startIndex;
              final int itemsInPage = remainingItems > yearsPerPage
                  ? yearsPerPage
                  : remainingItems;

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 40,
                  mainAxisSpacing: 10,
                ),
                itemCount: itemsInPage,
                itemBuilder: (context, i) {
                  final int globalIndex = startIndex + i;
                  final int year = widget.startYear + globalIndex;

                  final isSelected = year == widget.selectedYear;
                  final isFuture = year > currentYear;
                  final isCurrent = year == currentYear;

                  return CalendarBaseCell(
                    text: '${CalendarUtils.toBuddhistYear(year)}',
                    textColor: isFuture
                        ? CustomColor.gray500
                        : CustomColor.gray900,
                    backgroundColor: isSelected
                        ? CustomColor.secondaryColor
                        : Colors.transparent,
                    isToday: isCurrent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ),
                    dotOffset: -8,
                    onTap: isFuture ? null : () => widget.onYearSelected(year),
                  );
                },
              );
            },
          ),
        ),

        // จุดบอกหน้า (Dots Indicator)
        if (totalPages > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalPages, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
