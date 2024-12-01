import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/coffee/advertisment/advertisment_viewModel.dart';
import 'package:template/features/coffee/advertisment/widgets/AddAdvertisement.dart';
import 'package:template/features/coffee/home/home_viewModel.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/features/coffee/home/widgets/AddCoffeShop.dart';
import 'package:template/features/coffee/home/widgets/ListAdvertisement.dart';
import 'package:template/features/coffee/home/widgets/ListCoffeeShops.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/empty_page.dart';

class CoffeeHomePage extends StatefulWidget {
  const CoffeeHomePage({Key? key}) : super(key: key);

  @override
  State<CoffeeHomePage> createState() => _CoffeeHomePageState();
}

class _CoffeeHomePageState extends State<CoffeeHomePage> {
  HomeViewModel viewModel = HomeViewModel();
  AdvertismentViewModel advertismentViewModel = AdvertismentViewModel();

  @override
  void initState() {
    advertismentViewModel.getAllAdvertisementForEveryUserID();
    viewModel.getAllCoffeeShopesForEveryUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kWhiteColor,
          title: Text("Home", style: AppStyles.kTextStyleHeader20,),
          centerTitle: true,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40),
              bottomLeft: Radius.circular(40),
            ),
            borderSide: BorderSide.none
          ),
        ),
        backgroundColor: AppColors.kSearchColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Addcoffeshop(viewModel: viewModel)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            // border: Border.all(color: AppColors.kMainColor),
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.kTextFieldColor,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.kGreyColor.withOpacity(.3),
                                blurStyle: BlurStyle.outer,
                                spreadRadius: 1
                              )
                            ]
                          ),
                          padding: EdgeInsets.all(10.sp),
                          child: Column(
                            children: [
                              AppSize.h20.ph,
                              Image.asset(Resources.add, height: 30.sp, color: AppColors.kMainColor,),
                              AppSize.h10.ph,
                              Text("Add Coffee Shop" , style: AppStyles.kTextStyle13,)
                            ],
                          ),
                        ),
                      ),
                    ),
      
                    AppSize.h20.pw,
      
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddAdvertisement(viewModel: viewModel, advertismentViewModel: advertismentViewModel,)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              // border: Border.all(color: AppColors.kMainColor),
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.kTextFieldColor,
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.kGreyColor.withOpacity(.3),
                                    blurStyle: BlurStyle.outer,
                                    spreadRadius: 1
                                )
                              ]
                          ),
                          padding: EdgeInsets.all(10.sp),
                          child: Column(
                            children: [
                              AppSize.h20.ph,
                              Image.asset(Resources.add, height: 30.sp, color: AppColors.kMainColor,),
                              AppSize.h10.ph,
                              Text("Advertisement Request" , style: AppStyles.kTextStyle13,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
      
                ),
              ),
      
              AppSize.h20.ph,
              Text("Coffee shops", style: AppStyles.kTextStyleHeader20,),
              AppSize.h5.ph,
              // coffee shops
              BlocBuilder<GenericCubit<List<CoffeeShope>>, GenericCubitState<List<CoffeeShope>>>(
                bloc: viewModel.coffeeShopes,
                builder: (context, state) {
                  return state.data.isEmpty?
                  const EmptyData(): ListCoffeeShops(shops: state.data, viewModel: viewModel,);
                }
              ),
          
              AppSize.h20.ph,
              Text("Approved Ads", style: AppStyles.kTextStyleHeader20,),
              AppSize.h5.ph,
              // Advertisement
              ListAdvertisement(viewModel: advertismentViewModel, homeViewModel: viewModel,)
            ],
          ),
        ),
      ),
    );
  }
}
