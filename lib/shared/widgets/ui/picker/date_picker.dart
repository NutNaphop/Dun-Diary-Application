import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/widgets/custom/svg/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/ui/picker/widgets/picker_slot.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateTimeChanged;

  const DatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PickerSlot(
      label: AppStrings.common.date,
      trailingIcon: SVGImage(
        path: AppIcons.outline.calendar,
        width: 20,
        height: 20,
      ),
      displayText: DateTimeUtils.formatToThaiDate(selectedDate),
      onTap: () => _selectDate(context),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      final newDateTime = DateTime(
        picked.year,
        picked.month,
        picked.day,
        selectedDate.hour,
        selectedDate.minute,
      );
      onDateTimeChanged(newDateTime);
    }
  }
}
