import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/user_viewModel.dart';
import 'package:template/features/toggleBetweenUsers/background_page.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  UserViewModel viewModel = UserViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: "Change Password"),
      body: BackgroundPage(
        whiteBG: true,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20.sp),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppSize.h40.ph,
                CustomField(
                  controller: viewModel.currentPassword,
                  obsecure: true,
                  fillColor: AppColors.kTextFieldColor,
                  hint: "Password",
                ),
                AppSize.h20.ph,
                CustomField(
                  controller: viewModel.newPassword,
                  obsecure: true,
                  fillColor: AppColors.kTextFieldColor,
                  hint: "New Password",
                ),
                AppSize.h20.ph,
                CustomField(
                  controller: viewModel.newPasswordConfirmation,
                  obsecure: true,
                  fillColor: AppColors.kTextFieldColor,
                  hint: "New Password Confirmation",
                ),
                AppSize.h40.ph,
                BlocBuilder<GenericCubit<bool>,
                    GenericCubitState<bool>>(
                    bloc: viewModel.loading,
                    builder: (context, state) {
                      return  state.data
                          ? const SizedBox(width: 40, height: 25, child: Loading())
                          : CustomButton(
                        title: "Update Password",
                        btnColor: AppColors.kBlackColor,
                        radius: 15,
                        onClick: (){
                          viewModel.updatePassword();
                        },
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
