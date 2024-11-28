import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/Customer/home/widgets/show_menu_details.dart';
import 'package:template/features/Customer/home/widgets/show_rate_details.dart';
import 'package:template/features/coffee/coffees/coffee_viewModel.dart';
import 'package:template/features/coffee/coffees/models/menu.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';

class ShowAllMenus extends StatefulWidget {
  final CoffeeShope coffeeShope;
  final CoffeeViewModel coffeeViewModel;
  const ShowAllMenus({Key? key, required this.coffeeShope, required this.coffeeViewModel}) : super(key: key);

  @override
  State<ShowAllMenus> createState() => _ShowAllMenusState();
}

class _ShowAllMenusState extends State<ShowAllMenus> {

  @override
  void initState() {
    widget.coffeeViewModel.getAllMenusByCoffeeShopID(widget.coffeeShope.id ?? "");
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20.sp),
              child: Image.asset(Resources.header),
            ),
            const Divider(color: AppColors.kBlackColor, thickness: 1,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(onTap: ()=>UI.pop(), child: Icon(Icons.arrow_back_ios_outlined,)),
                Text(widget.coffeeShope.name??"", style: AppStyles.kTextStyleHeader26,),
                AppSize.h10.pw
              ],
            ),

            Padding(
              padding: EdgeInsets.all(10.sp),
              child: Text("Menu Item", style: AppStyles.kTextStyleHeader26,),
            ),
            BlocBuilder<GenericCubit<List<Menu>>, GenericCubitState<List<Menu>>>(
                bloc: widget.coffeeViewModel.menus,
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
                  Wrap(
                    children: List.generate(menus.length, (index){
                      return SizedBox(
                        height: 180.sp,
                        width: (MediaQuery.of(context).size.width) /2,
                        child: Padding(
                          padding: EdgeInsets.all(10.0.sp),
                          child: Card(
                            color: AppColors.kWhiteColor,
                            shadowColor: AppColors.kBackgroundColor,
                            elevation: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppSize.h5.ph,
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    menus[index].image ?? "",
                                    height: 60.sp,
                                    width: 60.sp,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                AppSize.h10.ph,
                                Text( menus[index].name ?? "",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.kTextStyle16.copyWith(
                                      color: AppColors.kBlackCColor
                                  ),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PrefManager.currentUser?.type == 2?
                                    IconButton(onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ShowMenuDetails(menu: menus[index],)));
                                    },
                                        icon: Image.asset(Resources.cart, height: 25.sp,)
                                    ): const SizedBox(),
                                    IconButton(onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ShowRateDetails(menu: menus[index],)));
                                    },
                                       icon: Image.asset(Resources.star, height: 25.sp, color: AppColors.kMainColor,)
                                    )
                                  ],
                                ),
                                AppSize.h5.ph,
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                 /* ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      var menu = menus.elementAt(index);
                      return InkWell(
                        onTap: (){
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => ShowMenuDetails(menu: menu,)));
                        },
                        child: Card(
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
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                AppSize.h10.ph,
                                Row(
                                  children: [
                                    Expanded(child: Text(menu.name ?? "", style: AppStyles.kTextStyleHeader13.copyWith(
                                        fontWeight: FontWeight.bold
                                    ),)),
                                    Row(
                                      children: [
                                        Text(menu.price.toString() ?? "", style: AppStyles.kTextStyle20,),
                                        AppSize.h5.pw,
                                        Text("R.S", style: AppStyles.kTextStyleHeader20,)
                                      ],
                                    )
                                  ],
                                ),
                                AppSize.h10.ph,
                                Row(
                                  children: [
                                    Expanded(child: Text(menu.description ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    AppSize.h10.pw,
                                    Row(
                                      children: [
                                        PrefManager.currentUser?.type == 2?
                                        IconButton(onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ShowMenuDetails(menu: menu,)));
                                        },
                                            icon: Icon(Icons.shopping_cart_rounded,
                                              size: 30.sp,
                                              color: Colors.black54,
                                            )
                                        ): const SizedBox(),
                                        IconButton(onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ShowRateDetails(menu: menu,)));
                                        },
                                            icon: Icon(Icons.star_rate_outlined,
                                              size: 30.sp,
                                              color: Colors.orangeAccent,
                                            )
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                AppSize.h5.ph,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index){
                      return AppSize.h5.pw;
                    },
                    itemCount: menus.length
                );*/
              }
            ),
          ],
        ),
      ),
    );
  }
}
