import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/user_viewModel.dart';
import 'package:template/features/toggleBetweenUsers/background_page.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserViewModel viewModel = UserViewModel();
  bool isHidden = true;
  bool isSavePass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Welcome Back!", style: AppStyles.kTextStyleHeader22,),
      ),
      body: BackgroundPage(
        child: Padding(
          padding: EdgeInsets.only(top: 30.sp),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              children: [
                AppSize.h50.ph,
                Text("Login", style: AppStyles.kTextStyleHeader20,),
                AppSize.h30.ph, // Space between the logo and the title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.sp),
                  child: CustomField(
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
                ),
                AppSize.h20.ph,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.sp),
                  child: CustomField(
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
                  ),
                ),
                AppSize.h10.ph,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.sp),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Checkbox(value: isSavePass, onChanged: (v){
                              setState(() {
                                isSavePass = v ?? false;
                              });
                            },),
                            const Text("Remember me"),
                          ],
                        ),
                      ),
                      Text("Forgot Password ?"),
                    ],
                  ),
                ),
                AppSize.h50.ph,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.sp),
                  child: CustomButton(
                      title: "Login",
                      btnColor: AppColors.kBlackColor,
                      onClick: (){
                        viewModel.login();
                      }
                  ),
                ),
                AppSize.h20.ph,
                Text("Discover your perfect cup !", style: AppStyles.kTextStyleHeader20,),
                AppSize.h20.ph,
                const Spacer(),
                InkWell(
                  onTap: () => UI.push(AppRoutes.toggleBetweenUsers),
                  child: Stack(
                    children: [
                      Container(
                        height: 250.sp,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 150.sp,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10.sp),
                          color: AppColors.kWhiteColor,
                          child: Text("Register", style: AppStyles.kTextStyleHeader36),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Row(
                          children: [
                            Container(
                              height: 150.sp,
                              width: 70.sp,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: AppColors.kWhiteColor
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(25.sp),
                                child: Image.asset(Resources.up),
                              ),
                            ),
                            Container(
                              height: 150.sp,
                              width: 70.sp,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: AppColors.kBackgroundColor
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(25.sp),
                                child: RotatedBox(quarterTurns: 2,child: Image.asset(Resources.up)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
