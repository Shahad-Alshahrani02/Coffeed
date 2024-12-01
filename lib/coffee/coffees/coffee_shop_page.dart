import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/coffee/coffees/coffee_viewModel.dart';
import 'package:template/features/coffee/coffees/models/menu.dart';
import 'package:template/features/coffee/coffees/widgets/AddMenu.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBar.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class CoffeeShopPage extends StatefulWidget {
  final CoffeeShope coffeeShope;
  const CoffeeShopPage({Key? key, required this.coffeeShope}) : super(key: key);

  @override
  State<CoffeeShopPage> createState() => _CoffeeShopPageState();
}

class _CoffeeShopPageState extends State<CoffeeShopPage> {

  CoffeeViewModel viewModel = CoffeeViewModel();

  @override
  void initState() {
    viewModel.getAllMenusByCoffeeShopID(widget.coffeeShope.id ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: widget.coffeeShope.name ?? ""),
      backgroundColor: AppColors.kSearchColor,
      body: Container(
        padding: EdgeInsets.all(10.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddMenu(viewModel: viewModel, coffeeShope: widget.coffeeShope,)));
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
                  padding: EdgeInsets.all(20.sp),
                  margin: EdgeInsets.symmetric(horizontal: 40.sp, vertical: 10.sp),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Image.asset(Resources.add, height: 30.sp, color: AppColors.kMainColor,),
                      AppSize.h10.ph,
                      Text("Add Menu" , style: AppStyles.kTextStyle13,)
                    ],
                  ),
                ),
              ),
              Divider(color: AppColors.kBlackCColor, thickness: 1),
              AppSize.h10.ph,
              Text("Coffee ${widget.coffeeShope.name} Menu", style: AppStyles.kTextStyleHeader20,),
              AppSize.h10.ph,
              BlocBuilder<GenericCubit<List<Menu>>, GenericCubitState<List<Menu>>>(
                  bloc: viewModel.menus,
                  builder: (context, state) {
                    return state is GenericLoadingState?
                    Loading():
                    state.data.isEmpty?
                        const EmptyData():
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        var menu = state.data.elementAt(index);
                        return Card(
                          color: AppColors.kWhiteColor,
                          elevation: 5,
                          child: Container(
                            padding: EdgeInsets.all(10.sp),
                            width: 220.sp,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    menu.image ?? "",
                                    height: 120.sp,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                AppSize.h10.ph,
                                Row(
                                  children: [
                                    Expanded(child: Text(menu.name ?? "", style: AppStyles.kTextStyleHeader13.copyWith(
                                        fontWeight: FontWeight.bold
                                    ),)),
                                    Column(
                                      children: [
                                        menu.poromotion == 0? Row(
                                          children: [
                                            Text(menu.price.toString() ?? "", style: AppStyles.kTextStyle20,),
                                            AppSize.h5.pw,
                                            Text("R.S", style: AppStyles.kTextStyleHeader20,)
                                          ],
                                        ): Row(
                                          children: [
                                            Text(menu.price.toString() ?? "", style: AppStyles.kTextStyle14.copyWith(
                                              decoration: TextDecoration.lineThrough
                                            ),),
                                            AppSize.h5.pw,
                                            Text("R.S", style: AppStyles.kTextStyleHeader14,)
                                          ],
                                        ),
                                        menu.poromotion == 0?  SizedBox():
                                        Row(
                                          children: [
                                            Text((menu.newPrice).toString() ?? "", style: AppStyles.kTextStyle20,),
                                            AppSize.h5.pw,
                                            Text("R.S", style: AppStyles.kTextStyleHeader20,)
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                AppSize.h10.ph,
                                Text(menu.description ?? ""),
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
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddMenu(viewModel: viewModel, coffeeShope: widget.coffeeShope, menu: menu,)));
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
                                                viewModel.deleteMenu(menu.id ?? "");
                                              });
                                        }
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index){
                        return AppSize.h5.pw;
                      },
                      itemCount: state.data.length
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
