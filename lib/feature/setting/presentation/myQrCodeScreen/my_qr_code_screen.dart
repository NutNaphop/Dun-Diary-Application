import 'package:dun_diary_app/core/auth/provider/global_user_provider.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/data/user/repository/user_repository.dart';
import 'package:dun_diary_app/feature/setting/presentation/myQrCodeScreen/my_qr_code_viewModel.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class MyQrCodeScreen extends StatefulWidget {
  const MyQrCodeScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) =>
          MyQrCodeViewmodel(userRepository: context.read<UserRepository>()),
      child: const MyQrCodeScreen(),
    );
  }

  @override
  State<MyQrCodeScreen> createState() => _MyQrCodeScreenState();
}

class _MyQrCodeScreenState extends State<MyQrCodeScreen> {
  @override
  Widget build(BuildContext context) {
    final userName = context.select((GlobalUserProvider p) => p.displayName);
    return CustomScaffold(
      usePadding: false,
      appBar: MainAppBar(
        title: "QR Code ของฉัน",
        showBack: true,
        onBackPressed: () {
          NavigationService.instance.goBack();
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SVGImage(
                  path: AppIcons.duotone.starCircle,
                  width: 24,
                  height: 24,
                ),
                CustomText(
                  text: "เก็บรหัสนี้ไว้ให้ปลอดภัย",
                  fontSize: Dimension.fontSizes.h2,
                  fontWeight: Dimension.fontWeights.bold,
                ),
              ],
            ),
            SizedBox(height: 10),
            CustomText(
              textAlign: TextAlign.center,
              text:
                  "ใช้สำหรับกู้คืนข้อมูลบัญชีของคุณ\nห้ามแบ่งปันรหัสกับผู้อื่น",
              fontSize: Dimension.fontSizes.md,
              fontWeight: Dimension.fontWeights.medium,
            ),
            SizedBox(height: 26),

            // QRCODE SECTION
            Screenshot(
              controller: context
                  .read<MyQrCodeViewmodel>()
                  .screenshotController,
              child: Center(
                child: context.watch<MyQrCodeViewmodel>().isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: QrImageView(
                              data: context.watch<MyQrCodeViewmodel>().qrData,
                              version: QrVersions.auto,
                              size: 270,
                            ),
                          ),
                          SizedBox(height: 20),
                          CustomText(
                            text: "ชื่อผู้ใช้ : ${userName}",
                            fontSize: Dimension.fontSizes.md,
                            fontWeight: Dimension.fontWeights.bold,
                            color: CustomColor.gray500,
                          ),
                        ],
                      ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "บันทึกรูปลงเครื่อง",
                type: CustomButtonType.fill,
                onPressed: context.read<MyQrCodeViewmodel>().snapImage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
