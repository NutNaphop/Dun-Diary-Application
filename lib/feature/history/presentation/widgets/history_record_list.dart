import 'package:dun_diary_app/feature/history/presentation/history_viewmodel.dart';
import 'package:dun_diary_app/feature/history/presentation/widgets/history_card.dart'; // Existing widget
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryRecordList extends StatefulWidget {
  const HistoryRecordList({super.key});

  @override
  State<HistoryRecordList> createState() => _HistoryRecordListState();
}

class _HistoryRecordListState extends State<HistoryRecordList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoryViewmodel>();

    return vm.selectedDateRecords.isEmpty
        ? const SizedBox.shrink()
        : CustomCard(
            title: AppStrings.history.recordTitle,
            contentPadding: const EdgeInsets.all(10),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250),
              child: RawScrollbar(
                thumbColor: CustomColor.gray300,
                radius: const Radius.circular(90),
                thickness: 4,
                thumbVisibility: true,
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: vm.selectedDateRecords.length,
                  itemBuilder: (context, index) {
                    final record = vm.selectedDateRecords[index];
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => vm.redirectToBloodPressureDetail(record),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: HistoryCard(
                          record: record,
                          isHaveDivider:
                              index != vm.selectedDateRecords.length - 1,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
  }
}
