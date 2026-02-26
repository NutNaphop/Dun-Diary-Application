import 'package:dun_diary_app/shared/utils/date_utils.dart'; // Ensure correct import
import 'package:dun_diary_app/shared/widgets/ui/date_slider/date_slider_item.dart';
import 'package:flutter/material.dart';

class DateSlider extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Color Function(DateTime)? dateColorBuilder;
  final DateTime? enableScrollFutureUntil;
  final bool Function(DateTime)? warningDotBuilder;

  const DateSlider({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.dateColorBuilder,
    this.enableScrollFutureUntil,
    this.warningDotBuilder,
  });

  @override
  State<DateSlider> createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  late PageController _pageController;
  final int _initialPage = 1000;

  // Cache the week range for the initial page to anchor our calculations
  late DateTime _anchorNonMonday;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
    _anchorNonMonday = DateTime.now();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (!mounted) return;

    final diffWeeks = index - _initialPage;

    // Calculate week start for the new page
    final anchorRange = DateTimeUtils.calculateDateRange(0, _anchorNonMonday);
    final anchorStart = anchorRange.start; // This is Monday
    final newWeekStart = anchorStart.add(Duration(days: 7 * diffWeeks));

    // Determine the current selected weekday (1=Mon, ..., 7=Sun)
    final currentSelected = widget.selectedDate;
    final currentWeekday = currentSelected.weekday;

    // Calculate the new date to select (same weekday in the new week)
    // newWeekStart is Monday (1).
    // Target is newWeekStart + (currentWeekday - 1) days.
    final targetDate = newWeekStart.add(Duration(days: currentWeekday - 1));

    // Verify if date actually changed to avoid loop
    if (targetDate.year != widget.selectedDate.year ||
        targetDate.month != widget.selectedDate.month ||
        targetDate.day != widget.selectedDate.day) {
      // Notify parent
      widget.onDateSelected(targetDate);
    }
  }

  @override
  void didUpdateWidget(covariant DateSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      final anchorRange = DateTimeUtils.calculateDateRange(0, _anchorNonMonday);
      final anchorStart = anchorRange.start;

      final targetRange = DateTimeUtils.calculateDateRange(
        0,
        widget.selectedDate,
      );
      final targetStart = targetRange.start;

      final diffWeeks = (targetStart.difference(anchorStart).inDays / 7)
          .round();
      final targetPage = _initialPage + diffWeeks;

      if (_pageController.hasClients &&
          _pageController.page?.round() != targetPage) {
        _pageController.jumpToPage(targetPage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int? itemCount;
    if (widget.enableScrollFutureUntil != null) {
      final anchorRange = DateTimeUtils.calculateDateRange(0, _anchorNonMonday);
      final limitRange = DateTimeUtils.calculateDateRange(
        0,
        widget.enableScrollFutureUntil!,
      );

      final diffWeeks =
          (limitRange.start.difference(anchorRange.start).inDays / 7).round();
      // +1 because index is 0-based and we want to include the limit week
      itemCount = _initialPage + diffWeeks + 1;
    }

    // ใช้ LayoutBuilder หรือแค่คืน PageView เพื่อให้ Parent เป็นคนคุมความสูง
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final diffWeeks = index - _initialPage;
              final anchorRange = DateTimeUtils.calculateDateRange(
                0,
                _anchorNonMonday,
              );
              final anchorStart = anchorRange.start;
              final weekStart = anchorStart.add(Duration(days: 7 * diffWeeks));

              return _buildWeekView(context, weekStart);
            },
          ),
        );
      },
    );
  }

  Widget _buildWeekView(BuildContext context, DateTime weekStart) {
    final days = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: days
          .map((date) => Expanded(child: _buildDayItem(context, date)))
          .toList(),
    );
  }

  Widget _buildDayItem(BuildContext context, DateTime date) {
    // Check if selected
    // Compare mainly YMD
    final isSelected =
        date.year == widget.selectedDate.year &&
        date.month == widget.selectedDate.month &&
        date.day == widget.selectedDate.day;

    // Use builder to get color, default to transparent if null or builder not provided
    final backgroundColor =
        widget.dateColorBuilder?.call(date) ?? Colors.transparent;

    return DateSliderItem(
      date: date,
      isSelected: isSelected,
      showWarningDot: widget.warningDotBuilder?.call(date) ?? false,
      backgroundColor: backgroundColor,
      onTap: () {
        widget.onDateSelected(date);
      },
    );
  }
}
