import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/data/user/repository/user_repository.dart';
import 'package:dun_diary_app/feature/setting/presentation/profileEditScreen/profile_edit_viewModel.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:dun_diary_app/shared/widgets/custom/textfield/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => ProfileEditViewModel(
        userRepository: context.read<UserRepository>(),
        authService: context.read<AuthService>(),
        networkInfo: context.read<NetworkInfo>(),
      ),
      child: const ProfileEditScreen(),
    );
  }

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileEditViewModel>();

    return CustomScaffold(
      usePadding: false,
      appBar: MainAppBar(
        title: "แก้ไขโปรไฟล์",
        showBack: true,
        backIconPath: AppIcons.outline.leftArrow,
        onBackPressed: NavigationService.instance.goBack,
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 80),
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 30,
            ),
            decoration: BoxDecoration(
              color: CustomColor.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: "ชื่อ",
                        controller: viewModel.nameController,
                        validator: _nameValidator,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: AppStrings.common.cancel,
                        onPressed: () {
                          NavigationService.instance.goBack();
                        },
                        type: CustomButtonType.outline,
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        text: AppStrings.common.save,
                        type: CustomButtonType.fill,
                        onPressed: () {
                          viewModel.saveProfile();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [DropShadow.drop_card],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(AppImages.profile.avatar1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกชื่อ';
    }
    return null;
  }
}
