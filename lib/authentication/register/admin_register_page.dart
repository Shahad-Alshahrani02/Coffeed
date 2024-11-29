import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/authentication/user_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';

class AdminRegisterPage extends StatefulWidget {
  final User? user;
  const AdminRegisterPage({Key? key, this.user}) : super(key: key);

  @override
  State<AdminRegisterPage> createState() => _AdminRegisterPageState();
}

class _AdminRegisterPageState extends State<AdminRegisterPage> {
  UserViewModel viewModel = UserViewModel();
  bool isHidden = true;

  @override
  void initState() {
    if(widget.user != null){
      viewModel.fillAdminData(widget.user!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        leading: InkWell(
          onTap: () => UI.pop(),
          child: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20.sp),
        child: Form(
          key: viewModel.formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10.sp),
            child: Column(
              children: [
                AppSize.h10.ph, // Space between the logo and the title
                Text(
                  "Update",
                  style: AppStyles.kTextStyleHeader36.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.kBlackColor,
                  ),
                ),
                AppSize.h40.ph,
                CustomField(
                  controller: viewModel.name,
                  hint: "Name",
                  validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                ),
                AppSize.h20.ph,
                CustomField(
                  controller: viewModel.email,
                  hint: "Email",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!viewModel.isValidEmail(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                AppSize.h20.ph,
                widget.user == null? CustomField(
                  controller: viewModel.password,
                  hint: "Password",
                  obsecure: isHidden,
                  suffix: IconButton(
                    icon: isHidden? Icon(Icons.visibility_off_outlined):
                    Icon(Icons.visibility_outlined),
                    onPressed: (){
                      setState(() {
                        isHidden =! isHidden;
                      });
                    },
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter your password' : null,
                ): const SizedBox(),
                widget.user == null? AppSize.h20.ph : const SizedBox(),
                CustomField(
                  controller: viewModel.phone,
                  hint: "Phone",
                  validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                ),
                AppSize.h20.ph,
                CustomField(
                  controller: viewModel.address,
                  hint: "Address",
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter your address' : null,
                ),
                AppSize.h40.ph,
                BlocBuilder<GenericCubit<bool>,
                    GenericCubitState<bool>>(
                    bloc: viewModel.loading,
                    builder: (context, state) {
                      return state.data
                          ? const Loading()
                          : CustomButton(
                        title: "Update",
                        btnColor: AppColors.kBlackCColor,
                        onClick: (){
                          if (widget.user != null){
                            viewModel.adminUpdateProfile(widget.user!.id!);
                          }else{
                            viewModel.adminRegister();
                          }
                        }
                    );
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
