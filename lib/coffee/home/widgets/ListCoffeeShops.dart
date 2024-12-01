import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/coffee/coffees/coffee_shop_page.dart';
import 'package:template/features/coffee/home/home_viewModel.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/features/coffee/home/widgets/AddCoffeShop.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';

class ListCoffeeShops extends StatelessWidget {
  final List<CoffeeShope> shops;
  final HomeViewModel viewModel;
  const ListCoffeeShops({Key? key, required this.shops, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270.sp,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index){
            var shop = shops.elementAt(index);
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CoffeeShopPage(coffeeShope: shop)));
              },
              child: Card(
                color: AppColors.kWhiteColor,
                child: Container(
                  padding: EdgeInsets.all(20.sp),
                  width: 250.sp,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          shop.logo ?? "",
                          height: 120.sp,
                          width: 200.sp,
                          fit: BoxFit.contain
                          ,
                        ),
                      ),
                      AppSize.h10.ph,
                      Row(
                        children: [
                          Expanded(child: Text(shop.name ?? "", style: AppStyles.kTextStyleHeader13.copyWith(
                            fontWeight: FontWeight.bold
                          ),)),
                          Expanded(
                            child: Row(
                              children: [
                                Image.asset(Resources.location, height: 15.sp, color: AppColors.kFogColor,),
                                AppSize.h5.pw,
                                Expanded(child: Text(shop.location ?? "", style: AppStyles.kTextStyle10, maxLines: 2,))
                              ],
                            ),
                          )
                        ],
                      ),
                      AppSize.h5.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                              title: "Update",
                              height: 30.sp,
                              width: 80.sp,
                              textSize: 13.sp,
                              btnColor: AppColors.kMainColor,
                              onClick: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Addcoffeshop(viewModel: viewModel, coffeeShope: shop,)));
                              }),
                          AppSize.h20.pw,
                          BlocBuilder<GenericCubit<bool>,
                              GenericCubitState<bool>>(
                              bloc: viewModel.loading,
                              builder: (context, state) {
                                return state.data
                                    ? const Loading()
                                    : CustomButton(
                                    title: "Delete",
                                    height: 30.sp,
                                    width: 80.sp,
                                    textSize: 13.sp,
                                    btnColor: AppColors.kRedColor,
                                    onClick: (){
                                      viewModel.deleteCoffeeShop(shop.id ?? "");
                                    });
                              }
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index){
            return AppSize.h5.pw;
          },
          itemCount: shops.length
      ),
    );
  }
}
