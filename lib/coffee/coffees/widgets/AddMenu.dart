import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/admin/home/admin_home_viewModel.dart';
import 'package:template/features/admin/home/models/Category.dart';
import 'package:template/features/coffee/coffees/coffee_viewModel.dart';
import 'package:template/features/coffee/coffees/models/menu.dart';
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
import 'package:template/shared/ui/componants/custom_dropdown.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class AddMenu extends StatefulWidget {
  final CoffeeViewModel viewModel;
  final CoffeeShope coffeeShope;
  final Menu? menu;
  const AddMenu({Key? key, required this.viewModel, required this.coffeeShope, this.menu}) : super(key: key);

  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  AdminHomeViewModel viewModel = AdminHomeViewModel();

  @override
  void initState() {
    viewModel.getAllCategoriesByCoffeeShopID(widget.coffeeShope.id ?? "");
    if(widget.menu != null){
      widget.viewModel.fillData(widget.menu!);
    }
    widget.viewModel.selectedCategory.onUpdateData(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: widget.menu != null ? "Update Menu" : "Add Menu"),
      body: BackgroundPage(
        whiteBG: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: widget.viewModel.formKey,
            child: ListView(
              children: [
                Material( 
                  shape: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.kGreyColor),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: CustomField(
                    controller: widget.viewModel.name,
                    hint: "Menu item name",
                    validator:  (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a coffee name';
                      }
                      return null;
                    },
                  ),
                ),
                AppSize.h20.ph,
                Material(
                  shape: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.kGreyColor),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: CustomField(
                    controller: widget.viewModel.description,
                    hint: "Description",
                    maxLines: 5,
                    validator:  (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                ),
        
                AppSize.h20.ph,
                Material(
                  shape: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.kGreyColor),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: CustomField(
                    controller: widget.viewModel.price,
                    hint: "Price",
                    keyboardType: TextInputType.number,
                    validator:  (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                  ),
                ),

                AppSize.h20.ph,
                Material(
                  shape: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.kGreyColor),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: CustomField(
                    controller: widget.viewModel.poromotion,
                    hint: "Promotion",
                    keyboardType: TextInputType.number,
                    validator:  (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid promotion';
                      }
                      return null;
                    },
                  ),
                ),
                widget.menu != null ? SizedBox(): AppSize.h20.ph,
        
                widget.menu != null ? SizedBox(): BlocBuilder<GenericCubit<List<Category>>, GenericCubitState<List<Category>>>(
                    bloc: viewModel.categories,
                    builder: (context, coffeState) {
                      return BlocBuilder<GenericCubit<Category?>, GenericCubitState<Category?>>(
                          bloc: widget.viewModel.selectedCategory,
                          builder: (context, state) {
                            print(state.data);
                            return coffeState is GenericLoadingState ?
                            Loading(): CustomDropdown(
                                value: state.data,
                                hint: "Select Category",
                                items: coffeState.data.map((e){
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name ?? "", style:  AppStyles.kTextStyleHeader14.copyWith(
                                      color: AppColors.kBlackColor,
                                    ),),
                                  );
                                }).toList(),
                                onChange: (e){
                                  print(e.id);
                                  print(e.name);
                                  widget.viewModel.selectedCategory.onUpdateData(e);
                                }
                            );
                          }
                      );
                    }
                ),
        
                AppSize.h20.ph,
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
        
                AppSize.h40.ph,
                BlocBuilder<GenericCubit<bool>,
                    GenericCubitState<bool>>(
                    bloc: widget.viewModel.loading,
                    builder: (context, state) {
                      return state is GenericLoadingState || state.data
                          ? const Loading()
                          :  CustomButton(title: widget.menu != null ? "Update Menu" : "Add Menu",
                          btnColor: AppColors.kBlackCColor,
                          onClick: (){
                            if(widget.menu != null){
                              widget.viewModel.updateMenu(widget.coffeeShope, widget.menu?.id ?? "");
                            }else{
                              widget.viewModel.addMenu(widget.coffeeShope);
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
