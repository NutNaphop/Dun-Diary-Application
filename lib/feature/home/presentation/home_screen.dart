import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/network/api_state.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/feature/home/data/repository/user_repository.dart';
import 'package:dun_diary_app/feature/home/presentation/home_viewModel.dart';
import 'package:dun_diary_app/feature/home/presentation/widgets/card/home_card_widget.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:dun_diary_app/shared/widgets/custom/svg/custom_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => HomeViewmodel(
        repo: context.read<UserRepository>(),
        networkInfo: context.read<NetworkInfo>(),
        authService: context.read<AuthService>(),
      ),
      child: const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HomeViewmodel>().fetchUser());
  }

  @override
  Widget build(BuildContext context) {
    final uiState = context.select((HomeViewmodel vm) => vm.state);
    final hasRecords = context.select((HomeViewmodel vm) => vm.hasRecords);
    final viewModel = context.read<HomeViewmodel>(); // เอาไว้กดปุ่ม

    return CustomScaffold(
      appBar: MainAppBar(
        isHome: true,
        title: "คุณเอกพจน์",
        actions: [
          IconButtonSVG(
            path: AppIcons.fill.notification,
            size: 32,
            onPressed: () {
              viewModel.toggleHasRecord();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: switch (uiState) {
          Initial() ||
          Loading() => const Center(child: CircularProgressIndicator()),

          Success() => Column(
            mainAxisSize: MainAxisSize.max,
            spacing: 25,
            children: [
              // --- ส่วนปุ่ม (Button) ---
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'เริ่มบันทึกความดัน',
                      textStyle: TextStyle(
                        color: CustomColor.gray900,
                        fontSize: Dimension.fontSizes.h2,
                        fontWeight: Dimension.fontWeights.regular,
                      ),
                      leadingIcon: SVGImage(
                        path: AppIcons.duotone.pulse,
                        size: 45,
                        color: CustomColor.primaryColor,
                      ),
                      trailingIcon: SVGImage(
                        path: AppIcons.duotone.addCircle,
                        size: 28,
                        color: CustomColor.primaryColor,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                      boxShadow: [DropShadow.drop_thumb],
                      onPressed: () {
                        viewModel.redirectToRecord();
                      },
                    ),
                  ),
                ],
              ),

              // --- ส่วนการ์ดแสดงผลสุขภาพ (Health Status Card) ---
              CustomCard(
                title: 'สุขภาพของคุณวันนี้',
                contentPadding: EdgeInsets.all(10),
                content: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (hasRecords) ...[
                      _buildStatRow(
                        context,
                        SVGImage(path: AppIcons.duotone.graphUp, size: 34,color: CustomColor.purple1),
                        'SYS',
                        'ความดันโลหิตขณะหัวใจบีบตัว',
                        '115',
                      ),
                      _buildStatRow(
                        context,
                        SVGImage(path: AppIcons.duotone.graphDown, size: 34, color: CustomColor.blue1),
                        'DIA',
                        'ความดันโลหิตขณะหัวใจคลายตัว',
                        '75',
                      ),
                      _buildStatRow(
                        context,
                        SVGImage(path: AppIcons.duotone.heartPulse, size: 34, color: CustomColor.pink1),
                        'PUL',
                        'อัตราการเต้นของหัวใจ',
                        '72',
                      ),
                    ] else ...[
                      NoFoundCard(
                        title: "ยังไม่มีเนื้อหา",
                        subtitle: "บันทึกความดันของวันนี้ เพื่อให้ข้อมูลสุขภาพสมบูรณ์",
                      ),
                    ],

                  ],
                ),
              ),
            ],
          ),

          Error(message: final msg) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red, size: 50),
                Text(msg),
              ],
            ),
          ),
        },
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     viewModel.addNewUser("BP Record ${DateTime.now().second}");
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

// Helper Widget เพื่อลดโค้ดที่ซ้ำซ้อนกัน 3 รอบ
Widget _buildStatRow(
  BuildContext context,
  Widget leading,
  String label,
  String description,
  String value,
) {
  return ContentCard(
    leading: leading,
    label: label,
    description: description,
    value: value,
  );
}