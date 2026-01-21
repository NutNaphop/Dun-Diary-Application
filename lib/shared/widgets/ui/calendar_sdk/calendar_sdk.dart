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

  const CalendarSDK({
    super.key,
    this.type = CalendarType.week,
    this.initialDate,
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
                  spacing: 20,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. Drop Down Header
                    CalendarHeader(
                      currentDate: viewModel.focusedDate,
                      style: CalendarUtils.getHeaderStyle(viewModel.currentView),
                      isSubPage: CalendarUtils.isSubPage(
                        type,
                        viewModel.currentView,
                      ),
                      onYearTap: viewModel.currentView == CalendarView.year
                          ? () {}
                          : viewModel.onHeaderYearTap,
                      onMonthTap: (viewModel.currentView == CalendarView.month ||
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
                      onSelect: () => Navigator.pop(context, viewModel.selectedDate),
                      onGoToToday: viewModel.onGoToToday,
                      todayButtonText: CalendarUtils.getTodayButtonText(type),
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
        return YearPickerView(
          selectedYear: viewModel.selectedDate.year,
          onYearSelected: viewModel.onYearSelected,
        );
    }
  }
}
