import 'package:dun_diary_app/feature/setting/presentation/recoveryMyDataScreen/recovery_my_data_viewModel.dart';
import 'package:dun_diary_app/feature/setting/presentation/widgets/card/profile_card.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/dialog/custom_dialog.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class RecoveryPreviewSection extends StatelessWidget {
  final RecoveryMyDataViewModel viewModel;

  const RecoveryPreviewSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.recoveredUser == null) return const SizedBox();

    final user = viewModel.recoveredUser!;

    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 52),
            child: Column(
              children: [
                // ดาวสีเหลือง
                SVGImage(
                  path: AppIcons.duotone.starCircle,
                  width: 100,
                  height: 100,
                  color: const Color.fromARGB(255, 248, 199, 2),
                ),
                const SizedBox(height: 24),

                CustomText(
                  text: "พบข้อมูลบัญชีแล้ว !",
                  fontSize: Dimension.fontSizes.h1,
                  fontWeight: Dimension.fontWeights.bold,
                ),
                const SizedBox(height: 12),

                CustomText(
                  text:
                      "ข้อมูลของคุณถูกกู้คืนเรียบร้อยแล้ว\nกรุณารีสตาร์ทแอปพลิเคชันเพื่อโหลดข้อมูลใหม่",
                  fontSize: Dimension.fontSizes.h2,
                  color: CustomColor.gray600,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                AbsorbPointer(
                  absorbing: true,
                  child: ProfileCard(onTap: () {}, userName: user.displayName),
                ),
              ],
            ),
          ),
        ),

        // ปุ่มรีสตาร์ทแอปพลิเคชัน
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: CustomButton(
            text: "รีสตาร์ทแอปพลิเคชัน",
            type: CustomButtonType.fill,
            onPressed: () {
              _showDeleteConfirmDialog(context);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showDeleteConfirmDialog(BuildContext context) async {
    final result = await CustomDialog.show<bool>(
      context,
      child: CustomDialog(
        title: "ยืนยันการกู้ข้อมูล",
        description:
            "ข้อมูลเดิมในเครื่องนี้จะถูกลบทิ้งทั้งหมด ยืนยันที่จะทำการกู้คืนข้อมูลหรือไม่?",
        primaryButtonText: "ตกลง",
        secondaryButtonText: "ยกเลิก",
        content: SVGImage(path: AppImages.faq, width: 163, height: 120),
      ),
    );

    if (result == true) {}
  }
}
