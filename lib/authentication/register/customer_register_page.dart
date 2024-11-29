import 'dart:io';

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
import 'package:template/shared/models/user_model.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/custom_dropdown.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class CustomerRegisterPage extends StatefulWidget {
  final User? user;
  const CustomerRegisterPage({Key? key, this.user}) : super(key: key);

  @override
  State<CustomerRegisterPage> createState() => _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends State<CustomerRegisterPage> {
  UserViewModel viewModel = UserViewModel();
  bool isHidden = true;

  @override
  void initState() {
    if(widget.user != null){
      viewModel.fillCustomerData(widget.user!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  widget.user != null ?
    Scaffold(
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
        padding:  widget.user != null ? null: EdgeInsets.symmetric(horizontal:20.sp),
        child: Form(
          key: viewModel.formKey,
          child: SingleChildScrollView(
            padding:  widget.user != null ? null: EdgeInsets.symmetric(vertical: 10.sp),
            child: Column(
              children: [
                AppSize.h10.ph,
                widget.user != null ? Text(
                  "Update Profile",
                  style: AppStyles.kTextStyleHeader36.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.kBlackColor,
                  ),
                ): const SizedBox(),
                AppSize.h20.ph,
                Padding(
                  padding:  widget.user == null ? EdgeInsets.all(0.sp): EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                  child: Column(
                    children: [
                      CustomField(
                        controller: viewModel.name,
                        hint: "Name",
                        fillColor: AppColors.kTextFieldColor,
                        validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                      ),
                      AppSize.h20.ph,
                      CustomField(
                        controller: viewModel.email,
                        hint: "Email",
                        fillColor: AppColors.kTextFieldColor,
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
                        fillColor: AppColors.kTextFieldColor,
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
                        fillColor: AppColors.kTextFieldColor,
                        validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                      ),
                      AppSize.h20.ph,
                      CustomField(
                        controller: viewModel.address,
                        fillColor: AppColors.kTextFieldColor,
                        hint: "Address",
                        validator: (value) =>
                        value!.isEmpty ? 'Please enter your address' : null,
                      ),
                      AppSize.h20.ph,
                      BlocBuilder<GenericCubit<File?>, GenericCubitState<File?>>(
                          bloc: viewModel.profile_image,
                          builder: (s, state){
                            return InkWell(
                              onTap:  viewModel.pickImage,
                              child: state.data != null ?
                              Container(
                                height: 100.sp,
                                width: 100.sp,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: AppColors.kFogColor, width: 5),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: FileImage(state.data!),
                                        fit: BoxFit.contain
                                    )
                                ),
                                padding: EdgeInsets.all(10.sp),
                              ):
                              Image.asset(Resources.add_image, height: 120.sp, width: 120.sp,),
                            );
                          }
                      ),
                      AppSize.h40.ph,
                      BlocBuilder<GenericCubit<bool>,
                          GenericCubitState<bool>>(
                          bloc: viewModel.loading,
                          builder: (context, state) {
                            return state.data
                                ? const Loading()
                                : CustomButton(
                                title: widget.user != null ? "Update": "Register",
                                btnColor: AppColors.kBlackColor,
                                onClick: (){
                                  if (widget.user != null){
                                    viewModel.customerUpdateProfile(widget.user!.id!);
                                  }else{
                                    viewModel.customerRegister();
                                  }
                                }
                            );
                          }
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ):
    Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding:  widget.user != null ? null: EdgeInsets.symmetric(horizontal:20.sp),
      child: Form(
        key: viewModel.formKey,
        child: SingleChildScrollView(
          padding:  widget.user != null ? null: EdgeInsets.symmetric(vertical: 10.sp),
          child: Column(
            children: [
              widget.user != null ?  ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                child: Image.asset(
                  Resources.logo,
                  height: MediaQuery.of(context).size.height*.4,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
              ): const SizedBox(),
              widget.user != null ? AppSize.h10.ph : SizedBox(), // Space between the logo and the title
              widget.user != null ? Text(
                "Update",
                style: AppStyles.kTextStyleHeader36.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.kBlackColor,
                ),
              ): const SizedBox(),

              Padding(
                padding:  widget.user == null ? EdgeInsets.all(0.sp): EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                child: Column(
                  children: [
                    CustomField(
                      controller: viewModel.name,
                      hint: "Name",
                      fillColor: AppColors.kTextFieldColor,
                      validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                    ),
                    AppSize.h20.ph,
                    CustomField(
                      controller: viewModel.email,
                      hint: "Email",
                      fillColor: AppColors.kTextFieldColor,
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
                      fillColor: AppColors.kTextFieldColor,
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
                      fillColor: AppColors.kTextFieldColor,
                      validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                    ),
                    AppSize.h20.ph,
                    CustomField(
                      controller: viewModel.address,
                      fillColor: AppColors.kTextFieldColor,
                      hint: "Address",
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter your address' : null,
                    ),
                    AppSize.h20.ph,
                    BlocBuilder<GenericCubit<File?>, GenericCubitState<File?>>(
                        bloc: viewModel.profile_image,
                        builder: (s, state){
                          return InkWell(
                            onTap:  viewModel.pickImage,
                            child: state.data != null ?
                            Container(
                              height: 100.sp,
                              width: 100.sp,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: AppColors.kFogColor, width: 5),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: FileImage(state.data!),
                                      fit: BoxFit.contain
                                  )
                              ),
                              padding: EdgeInsets.all(10.sp),
                            ):
                            Image.asset(Resources.add_image, height: 120.sp, width: 120.sp,),
                          );
                        }
                    ),
                    AppSize.h40.ph,
                    BlocBuilder<GenericCubit<bool>,
                        GenericCubitState<bool>>(
                        bloc: viewModel.loading,
                        builder: (context, state) {
                          return state.data
                              ? const Loading()
                              : CustomButton(
                              title: widget.user != null ? "Update": "Register",
                              btnColor: AppColors.kBlackColor,
                              onClick: (){
                                if (widget.user != null){
                                  viewModel.customerUpdateProfile(widget.user!.id!);
                                }else{
                                  viewModel.customerRegister();
                                }
                              }
                          );
                        }
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
