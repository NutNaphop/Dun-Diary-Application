import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/utils/calendar_config.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/views/day_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calendar_view_model.dart';
import 'components/calendar_footer.dart';
import 'components/calendar_header.dart';
import 'models/calendar_types.dart';
import 'utils/calendar_utils.dart';
import 'views/month_view.dart';
import 'views/week_view.dart';
import 'views/year_view.dart';

class CalendarSDK extends StatelessWidget {
  final CalendarType type;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CalendarSDK({
    super.key,
    this.type = CalendarType.week,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarViewModel(
        type: type,
        initialDate: initialDate ?? DateTime.now(),
      ),
      child: Consumer<CalendarViewModel>(
        builder: (context, viewModel, child) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: 350,
                child: Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. Drop Down Header
                    CalendarHeader(
                      currentDate: viewModel.focusedDate,
                      style: CalendarUtils.getHeaderStyle(
                        viewModel.currentView,
                      ),
                      isSubPage: CalendarUtils.isSubPage(
                        type,
                        viewModel.currentView,
                      ),
                      onYearTap: viewModel.currentView == CalendarView.year
                          ? () {}
                          : viewModel.onHeaderYearTap,
                      onMonthTap:
                          (viewModel.currentView == CalendarView.month ||
                              type == CalendarType.year)
                          ? () {}
                          : viewModel.onHeaderMonthTap,
                    ),

                    // 2. Body Change as Stage
                    Flexible(
                      child: SingleChildScrollView(
                        child: _buildBody(viewModel),
                      ),
                    ),

                    // 3. Footer Button (Select)
                    CalendarFooter(
                      isSubPage: CalendarUtils.isSubPage(
                        type,
                        viewModel.currentView,
                      ),
                      onSelect: () =>
                          Navigator.pop(context, viewModel.selectedDate),
                      onGoToPresent: viewModel.onGoToToday,
                      goToPresentLabel: CalendarUtils.getTodayButtonText(type),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(CalendarViewModel viewModel) {
    switch (viewModel.currentView) {
      case CalendarView.day:
        return DayPickerView(
          selectedDate: viewModel.selectedDate,
          focusedDay: viewModel.focusedDate,
          onDaySelected: viewModel.onDaySelected,
          onPageChanged: viewModel.onPageChanged,
        );
      case CalendarView.week:
        return WeekPickerView(
          selectedDate: viewModel.selectedDate,
          focusedDay: viewModel.focusedDate,
          onDaySelected: viewModel.onDaySelected,
          onPageChanged: viewModel.onPageChanged,
        );

      case CalendarView.month:
        return MonthPickerView(
          selectedMonth: viewModel.selectedDate.month,
          selectedYear: viewModel.selectedDate.year,
          viewingYear: viewModel.focusedDate.year,
          onMonthSelected: viewModel.onMonthSelected,
        );

      case CalendarView.year:
        final now = CalendarConfig.now;
        final int endYear = lastDate?.year ?? now.year;
        final int startYear = firstDate?.year ?? now.year;

        return YearPickerView(
          selectedYear: viewModel.focusedDate.year,
          startYear: startYear,
          endYear: endYear,
          onYearSelected: viewModel.onYearSelected,
        );
    }
  }
}
