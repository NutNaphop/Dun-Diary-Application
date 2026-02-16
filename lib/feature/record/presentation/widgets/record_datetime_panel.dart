import 'package:dun_diary_app/feature/record/presentation/record_viewModel.dart';
import 'package:dun_diary_app/shared/widgets/ui/picker/date_picker.dart';
import 'package:dun_diary_app/shared/widgets/ui/picker/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordDateTimePanel extends StatelessWidget {
  final bool isReadOnly;

  const RecordDateTimePanel({super.key, required this.isReadOnly});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isReadOnly ? 0.5 : 1.0,
      child: AbsorbPointer(
        absorbing: isReadOnly,
        child: Selector<RecordViewmodel, DateTime>(
          selector: (_, viewModel) => viewModel.recordDate,
          builder: (context, recordDate, child) => Row(
            children: [
              Expanded(
                child: DatePicker(
                  selectedDate: recordDate,
                  onDateTimeChanged: (val) =>
                      context.read<RecordViewmodel>().setRecordDate(val),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TimePicker(
                  selectedDate: recordDate,
                  onDateTimeChanged: (val) =>
                      context.read<RecordViewmodel>().setRecordDate(val),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
