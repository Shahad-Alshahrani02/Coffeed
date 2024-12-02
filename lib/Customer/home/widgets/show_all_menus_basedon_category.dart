import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/Customer/cart/widgets/CartIconWidget.dart';
import 'package:template/features/Customer/home/widgets/show_all_menus.dart';
import 'package:template/features/Customer/home/widgets/show_menu_details.dart';
import 'package:template/features/Customer/home/widgets/show_rate_details.dart';
import 'package:template/features/admin/home/models/Category.dart';
import 'package:template/features/coffee/coffees/coffee_viewModel.dart';
import 'package:template/features/coffee/coffees/models/menu.dart';
import 'package:template/features/coffee/home/home_viewModel.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';

class ShowAllMenusBasedonCategory extends StatefulWidget {
  final CoffeeViewModel coffeeViewModel;
  final Category category;
  const ShowAllMenusBasedonCategory({Key? key, required this.coffeeViewModel, required this.category,}) : super(key: key);

  @override
  State<ShowAllMenusBasedonCategory> createState() => _ShowAllMenusBasedonCategoryState();
}

class _ShowAllMenusBasedonCategoryState extends State<ShowAllMenusBasedonCategory> {
  HomeViewModel homeViewModel = HomeViewModel();
  final random =  Random();
  @override
  void initState() {
    widget.coffeeViewModel.getAllMenusByCategoryName(widget.category.name ?? "");
    homeViewModel.getAllCoffeeShopsSortingBaseLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Padding(
        //   padding: EdgeInsets.all(10.sp),
        //   child: Image.asset(Resources.notify),
        // ),
        title: CustomField(
          controller: widget.coffeeViewModel.search,
          fillColor: AppColors.kSearchColor,
          prefix: Padding(
            padding: EdgeInsets.all(12.sp),
            child: Image.asset(Resources.search, height: 15.sp, width: 15.sp, fit: BoxFit.fill,),
          ),
        ),
        toolbarHeight: 80.sp,
        leadingWidth: 30.sp,
        shape: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)
            )
        ),
        centerTitle: true,
        // automaticallyImplyLeading: false,
        backgroundColor: AppColors.kWhiteColor,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(vertical:15.sp),
            child: CartIconWidget(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Card(
                 color: AppColors.kWhiteColor,
                 elevation: 10,
                 shape: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(40),
                   borderSide: BorderSide.none
                 ),
                 child: Padding(
                   padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 40.sp),
                 child: Text(widget.category.name??"", style: AppStyles.kTextStyleHeader26,),
                 ),
               ),
             ],
           ),

            AppSize.h20.ph,
            Text("10 most popular", style: AppStyles.kTextStyle22,),

            BlocBuilder<GenericCubit<List<CoffeeShope>>, GenericCubitState<List<CoffeeShope>>>(
                bloc: homeViewModel.allCoffeeShopesBaseOnCategory,
                builder:  (context, state) {
                  var menus = state.data;
                  return state is GenericLoadingState ?
                  Container(
                      height: 220.sp,
                      alignment: Alignment.center,
                      child: const Loading()):
                  menus.isEmpty?
                  Container(
                      height: 200.sp,
                      alignment: Alignment.center,
                      child: const EmptyData()):
                  Container(
                    height: 100.sp,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                      double ran = (1 + random.nextInt(20)).toDouble();
                      double star = (1 + random.nextInt(5)).toDouble();
                      return InkWell(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context){
                                return ShowAllMenus(coffeeShope: menus[index], coffeeViewModel: widget.coffeeViewModel,);
                              })
                          );
                        },
                        child: Card(
                          color: AppColors.kWhiteColor,
                          child: Container(
                            width: 160.sp,
                            padding: EdgeInsets.all(10.0.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppSize.h10.pw,
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    menus[index].logo ?? "",
                                    height: 45.sp,
                                    width: 45.sp,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                AppSize.h10.pw,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(menus[index].name ?? "",
                                        maxLines: 1,
                                        style: AppStyles.kTextStyleHeader16.copyWith(
                                            color: AppColors.kBlackCColor,
                                            fontWeight: FontWeight.bold
                                        ),),
                                      Text(menus[index].ownerData?.name ?? "",
                                        maxLines: 2,
                                        style: AppStyles.kTextStyle14.copyWith(
                                            color: AppColors.kBlackCColor
                                        ),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }, separatorBuilder: (context, index){
                      return AppSize.h10.pw;
                    }, itemCount: menus.length),
                  );
                }
            ),

            AppSize.h20.ph,
            Text("Top rated", style: AppStyles.kTextStyle22,),
            BlocBuilder<GenericCubit<List<Menu>>, GenericCubitState<List<Menu>>>(
                bloc: widget.coffeeViewModel.menusBaseOnCategoy,
                builder:  (context, state) {
                  var menus = state.data;
                  return state is GenericLoadingState ?
                  Container(
                      height: 400.sp,
                      alignment: Alignment.center,
                      child: const Loading()):
                  menus.isEmpty?
                  Container(
                      height: 400.sp,
                      alignment: Alignment.center,
                      child: const EmptyData()):
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        double ran = (1 + random.nextInt(20)).toDouble();
                        double star = (1 + random.nextInt(5)).toDouble();
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ShowMenuDetails(menu: menus[index],)));
                          },
                          child: Card(
                            color: AppColors.kWhiteColor,
                            child: Container(
                              padding: EdgeInsets.all(10.0.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      menus[index].image ?? "",
                                      height: 65.sp,
                                      width: 65.sp,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  AppSize.h10.pw,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(menus[index].name ?? "",
                                          maxLines: 2,
                                          style: AppStyles.kTextStyleHeader18.copyWith(
                                              color: AppColors.kBlackCColor,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => ShowRateDetails(menu:  menus[index],)));
                                              },
                                              child: Row(
                                                children: [
                                                  Text(star.toString(),
                                                    maxLines: 2,
                                                    style: AppStyles.kTextStyleHeader12.copyWith(
                                                        color: AppColors.kBlackCColor
                                                    ),),
                                                  AppSize.h5.pw,
                                                  Image.asset(Resources.rate_calc, height: 20.sp, color: AppColors.kBackgroundColor,),
                                                ],
                                              ),
                                            ),
                                            AppSize.h20.pw,
                                            Text(ran.toString() + " Km",
                                              maxLines: 2,
                                              style: AppStyles.kTextStyleHeader12.copyWith(
                                                  color: AppColors.kBlackCColor
                                              ),),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index){
                        return AppSize.h10.pw;
                      },
                      itemCount: menus.length
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
