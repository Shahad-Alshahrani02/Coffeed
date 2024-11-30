import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:template/features/admin/home/admin_home_viewModel.dart';
import 'package:template/features/admin/home/models/Category.dart';
import 'package:template/features/coffee/advertisment/advertisment_viewModel.dart';
import 'package:template/features/coffee/advertisment/models/advertisment.dart';
import 'package:template/features/coffee/coffees/coffee_viewModel.dart';
import 'package:template/features/coffee/home/home_viewModel.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
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

class AddAdvertisement extends StatefulWidget {
  final HomeViewModel viewModel;
  final AdvertismentViewModel advertismentViewModel;
  final Advertisment? advertisment;
  const AddAdvertisement({Key? key, required this.viewModel, required this.advertismentViewModel, this.advertisment}) : super(key: key);

  @override
  State<AddAdvertisement> createState() => _AddAdvertisementState();
}

class _AddAdvertisementState extends State<AddAdvertisement> {
  AdvertismentViewModel viewModel = AdvertismentViewModel();

  @override
  void initState() {
    viewModel = widget.advertismentViewModel;
    viewModel.selectedCoffeeShop.onUpdateData(null);
    widget.viewModel.getAllCoffeeShops();
    if(widget.advertisment != null){
      viewModel.fillData(widget.advertisment!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: widget.advertisment != null ? "Update Advertisement" : "Add Advertisement"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: viewModel.formKey,
          child: ListView(
            children: [
              Material(
                shape: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.kGreyColor),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: CustomField(
                  controller: viewModel.title,
                  hint: "Title",
                  validator:  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
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
                  controller: viewModel.description,
                  maxLines: 5,
                  hint: "Description",
                  validator:  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ),

              AppSize.h20.ph,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(Resources.calendar, height: 30.sp,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () => viewModel.selectDate(context, true),
                        child: const Text('Select Start Date'),
                      ),
                      BlocBuilder<GenericCubit<DateTime>, GenericCubitState<DateTime>>(
                        bloc: viewModel.startDate,
                        builder: (context, state) {
                          return Text(
                            'Start Date: ${state.data != null ? DateFormat('yyyy-MM-dd').format(state.data!) : 'Not Selected'}',
                          );
                        }
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () => viewModel.selectDate(context, false),
                        child: Text('Select End Date'),
                      ),
                      BlocBuilder<GenericCubit<DateTime>, GenericCubitState<DateTime>>(
                          bloc: viewModel.endDate,
                          builder: (context, state) {
                            return Text(
                              'End Date: ${state.data != null ? DateFormat('yyyy-MM-dd').format(state.data!) : 'Not Selected'}',
                            );
                          }
                      ),
                    ],
                  ),
                ],
              ),

              AppSize.h20.ph,

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.sp),
                child: Material(
                  shape: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.kGreyColor),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: CustomField(
                    controller: viewModel.price,
                    hint: "Price",
                    keyboardType: TextInputType.number,
                    validator:  (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              AppSize.h20.ph,

              widget.advertisment != null ? SizedBox(): BlocBuilder<GenericCubit<List<CoffeeShope>>, GenericCubitState<List<CoffeeShope>>>(
                  bloc: widget.viewModel.allCoffeeShopes,
                  builder: (context, coffeState) {
                    return BlocBuilder<GenericCubit<CoffeeShope?>, GenericCubitState<CoffeeShope?>>(
                        bloc: viewModel.selectedCoffeeShop,
                        builder: (context, state) {
                          print(state.data);
                          return coffeState is GenericLoadingState ?
                          Loading(): CustomDropdown(
                              value: state.data,
                              hint: "Select Coffee Shop",
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
                                viewModel.selectedCoffeeShop.onUpdateData(e);
                              }
                          );
                        }
                    );
                  }
              ),

              widget.advertisment != null ? SizedBox():  AppSize.h20.ph,
              BlocBuilder<GenericCubit<File?>, GenericCubitState<File?>>(
                  bloc: viewModel.imageFile,
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
                      Image.asset(Resources.add_image, height: 80.sp, color: AppColors.kBlackCColor,),
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
                        :  CustomButton(title: widget.advertisment != null ? "Update Request" : "Request",
                        btnColor: AppColors.kBlackCColor,
                        onClick: (){
                          if(widget.advertisment != null){
                            viewModel.updateAdvertisement(widget.advertisment?.id ?? "");
                          }else{
                            viewModel.addAdvertisement();
                          }
                        });
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}
