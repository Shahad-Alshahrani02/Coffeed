import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/coffee/home/home_viewModel.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/features/toggleBetweenUsers/background_page.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class Addcoffeshop extends StatefulWidget {
  final HomeViewModel viewModel;
  final CoffeeShope? coffeeShope;
  const Addcoffeshop({Key? key, required this.viewModel, this.coffeeShope}) : super(key: key);

  @override
  State<Addcoffeshop> createState() => _AddcoffeshopState();
}

class _AddcoffeshopState extends State<Addcoffeshop> {

  @override
  void initState() {
    if(widget.coffeeShope != null){
      widget.viewModel.fillData(widget.coffeeShope!);
    }else{
      widget.viewModel.checkLocationPermission();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: widget.coffeeShope != null? "Update Coffee Shop" : "Add Coffee Shop"),
      body: BackgroundPage(
        whiteBG: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: widget.viewModel.formKey,
            child: ListView(
              children: [
                BlocBuilder<GenericCubit<File?>, GenericCubitState<File?>>(
                    bloc: widget.viewModel.imageFile,
                    builder: (s, state){
                      return InkWell(
                        onTap:  widget.viewModel.pickImage,
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
                        Image.asset(Resources.gallery, height: 80.sp, color: AppColors.kBlackCColor,),
                      );
                    }
                ),
                AppSize.h20.ph,
                CustomField(
                  controller: widget.viewModel.name,
                  hint: "Coffee name",
                  fillColor: AppColors.kBackgroundColor,
                  validator:  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a coffee name';
                    }
                    return null;
                  },
                ),
                AppSize.h20.ph,
                CustomField(
                  controller: widget.viewModel.location,
                  hint: "Location",
                  fillColor: AppColors.kBackgroundColor,
                  validator:  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                AppSize.h20.ph,
                CustomField(
                  controller: widget.viewModel.phone,
                  hint: "Contact details",
                  keyboardType: TextInputType.number,
                  fillColor: AppColors.kBackgroundColor,
                  validator:  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid Contact details';
                    }
                    return null;
                  },
                ),
                AppSize.h20.ph,

                Row(
                  children: [
                    Expanded(
                      child: CustomField(
                        controller: widget.viewModel.openingHours,
                        hint: "Opening hours",
                        fillColor: AppColors.kBackgroundColor,
                        keyboardType: TextInputType.number,
                        validator:  (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an opening hours';
                          }
                          return null;
                        },
                      ),
                    ),

                    AppSize.h10.pw,

                    Expanded(
                      child: CustomField(
                        controller: widget.viewModel.closingHours,
                        hint: "Closing hours",
                        fillColor: AppColors.kBackgroundColor,
                        keyboardType: TextInputType.number,
                        validator:  (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an closing hours';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                AppSize.h40.ph,
                BlocBuilder<GenericCubit<bool>,
                    GenericCubitState<bool>>(
                    bloc: widget.viewModel.loading,
                    builder: (context, state) {
                      return state is GenericLoadingState || state.data
                          ? const Loading()
                          :  CustomButton(title: widget.coffeeShope != null? "Update Coffee Shop" : "Add Coffee Shop",
                          btnColor: AppColors.kBlackCColor,
                          onClick: (){
                            if(widget.coffeeShope != null){
                              widget.viewModel.updateCoffeeShope(widget.coffeeShope!.id!);
                            }else {
                              widget.viewModel.addCoffeeShope();
                            }
                          });
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
