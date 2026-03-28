import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/core/services/media_service.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/feature/record/presentation/record_viewModel.dart';
import 'package:dun_diary_app/feature/record/presentation/widgets/record_action_buttons.dart';
import 'package:dun_diary_app/feature/record/presentation/widgets/record_bp_card.dart';
import 'package:dun_diary_app/feature/record/presentation/widgets/record_datetime_panel.dart';
import 'package:dun_diary_app/feature/record/presentation/widgets/record_gauge_card.dart';
import 'package:dun_diary_app/feature/record/presentation/widgets/record_view_menu.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ViewMode { read, edit }

class RecordScreenArgs {
  final BPRecord? record;
  final DateTime? initialDate;

  const RecordScreenArgs({this.record, this.initialDate});
}

class RecordScreen extends StatelessWidget {
  final BPRecord? record;

  const RecordScreen({super.key, this.record});

  static Widget create() {
    return _createProvider(RecordScreenArgs());
  }

  static Widget createWithRecord(RecordScreenArgs args) {
    return _createProvider(args);
  }

  static Widget _createProvider(RecordScreenArgs args) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = RecordViewmodel(
          repository: context.read<BloodPressureRepository>(),
          authService: context.read<AuthService>(),
          mediaService: context.read<MediaService>(),
          networkInfo: context.read<NetworkInfo>(),
        );
        vm.init(args.record, args.initialDate);
        return vm;
      },
      child: const RecordScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use watch to rebuild when state changes (e.g. isReadOnly)
    final viewModel = context.watch<RecordViewmodel>();
    final isReadOnly = viewModel.isReadOnly;

    return CustomScaffold(
      appBar: MainAppBar(
        title: isReadOnly
            ? AppStrings.record.detailTitle
            : (viewModel.hasExistingData
                  ? AppStrings.record.editTitle
                  : AppStrings.record.recordBloodPressure),
        showBack: true,
        backIconPath: AppIcons.outline.x,
        onBackPressed: () => NavigationService.instance.goBack(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 36),
        child: Column(
          children: [
            Opacity(
              opacity: isReadOnly ? 0.7 : 1.0,
              child: AbsorbPointer(
                absorbing: isReadOnly,
                child: const RecordBpCard(),
              ),
            ),

            const SizedBox(height: 15),

            const RecordGaugeCard(),

            const SizedBox(height: 25),

            // Date time picker
            RecordDateTimePanel(isReadOnly: isReadOnly),

            Spacer(),

            isReadOnly ? const RecordViewMenu() : const RecordActionButtons(),
          ],
        ),
      ),
    );
  }
}
