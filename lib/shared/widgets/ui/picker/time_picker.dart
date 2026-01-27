import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/widgets/custom/svg/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/ui/picker/widgets/picker_slot.dart';
import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateTimeChanged;

  const TimePicker({
    super.key,
    required this.selectedDate,
    required this.onDateTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PickerSlot(
      label: AppStrings.common.time,
      trailingIcon: SVGImage(
        path: AppIcons.outline.clock,
        width: 20,
        height: 20,
      ),
      displayText: DateTimeUtils.formatToTime(selectedDate),
      onTap: () => _selectTime(context),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );
    if (picked != null) {
      final newDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        picked.hour,
        picked.minute,
      );
      onDateTimeChanged(newDateTime);
    }
  }
}
