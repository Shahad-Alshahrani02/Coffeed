import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:template/features/Customer/cart/widgets/CartIconWidget.dart';
import 'package:template/features/Customer/home/widgets/menu_page.dart';
import 'package:template/features/Customer/home/widgets/show_all_category.dart';
import 'package:template/features/Customer/home/widgets/show_all_coffees.dart';
import 'package:template/features/Customer/home/widgets/show_all_menus.dart';
import 'package:template/features/Customer/home/widgets/show_all_menus_basedon_category.dart';
import 'package:template/features/admin/home/admin_home_viewModel.dart';
import 'package:template/features/admin/home/models/Category.dart';
import 'package:template/features/coffee/advertisment/advertisment_viewModel.dart';
import 'package:template/features/coffee/advertisment/models/advertisment.dart';
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
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AdvertismentViewModel advertismentViewModel = AdvertismentViewModel();
  HomeViewModel homeViewModel = HomeViewModel();
  AdminHomeViewModel adminHomeViewModel = AdminHomeViewModel();
  CoffeeViewModel coffeeViewModel = CoffeeViewModel();
  int _index = 0;

  final random =  Random();

  @override
  void initState() {
    advertismentViewModel.getAllAdvertisements();
    adminHomeViewModel.getAllCategories();
    homeViewModel.getAllCoffeeShops();
    coffeeViewModel.getAllMenus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Image.asset(Resources.notify),
        ),
        title: CustomField(
            controller: homeViewModel.search,
            fillColor: AppColors.kSearchColor,
            prefix: Padding(
              padding: EdgeInsets.all(12.sp),
              child: Image.asset(Resources.search, height: 15.sp, width: 15.sp, fit: BoxFit.fill,),
            ),
          suffix: Padding(
              padding: EdgeInsets.all(12.sp),
              child: Image.asset(Resources.filter, height: 15.sp, width: 15.sp, fit: BoxFit.fill,),
            ),
        ),
        toolbarHeight: 80.sp,
        shape: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)
            )
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.kWhiteColor,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(vertical:15.sp),
            child: CartIconWidget(),
          )
        ],
      ),
      backgroundColor: AppColors.kSearchColor,
      body: Container(
        padding: EdgeInsets.all(10.sp),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Hello ${PrefManager.currentUser?.name}", style: AppStyles.kTextStyle14,),
                    Row(
                      children: [
                        Image.asset(Resources.location, height: 20.sp,),
                        AppSize.h5.pw,
                        Text(PrefManager.currentUser?.address ?? ""),
                      ],
                    )
                  ],
                ),
              ),
              BlocBuilder<GenericCubit<List<Advertisment>>, GenericCubitState<List<Advertisment>>>(
                  bloc: advertismentViewModel.allAdvertisments,
                  builder:  (context, state) {
                    return state is GenericLoadingState ?
                    const SizedBox()
                        : CarouselSlider(
                    options: CarouselOptions(
                        height: 150.sp,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        disableCenter: true,
                        pageSnapping: false
                    ),
                    items: state.data.map((data) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.kInputColor,
                                width: 4
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 150.sp,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(data.image ?? ""), // Replace with your offer image paths
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 10,
                                  bottom: 10,
                                  child: CustomButton(title: "Order Now",
                                      onClick: (){

                                      },
                                    radius: 20,
                                    textSize: 12.sp,
                                    btnColor: AppColors.kBlackColor,
                                    height: 30.sp,
                                    width: 100,
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: Text("Cuppa", style: AppStyles.kTextStyleHeader20.copyWith(
                                    fontStyle: FontStyle.italic
                                  ),),
                                ),
                                Positioned(
                                  left: 10,
                                  right: 10,
                                  top: 10,
                                  child: Text(data.title ?? "",
                                    style: AppStyles.kTextStyleHeader20.copyWith(
                                    fontStyle: FontStyle.italic
                                  ),maxLines: 2,),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                }
              ),
              AppSize.h10.ph,
              /*BlocBuilder<GenericCubit<List<CoffeeShope>>, GenericCubitState<List<CoffeeShope>>>(
                  bloc: homeViewModel.allCoffeeShopes,
                  builder:  (context, state) {
                    List<CoffeeShope> shops =  [];
                       shops.add(CoffeeShope(
                         id: "0",
                         name: "All Coffees",
                         logo: "https://firebasestorage.googleapis.com/v0/b/coffe-80f60.appspot.com/o/all-inclusive.png?alt=media&token=539c0afc-2464-4d96-913e-807e69848ece"
                       ));
                       state.data.forEach((e){
                         shops.add(e);
                       });
                    return state is GenericLoadingState ?
                    const SizedBox():
                    Container(
                      height: 130.sp,
                      child: ListView.separated(scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index){
                             return InkWell(
                              onTap: (){
                                if(shops[index] == "0"){
                                  coffeeViewModel.allMenus.onUpdateData([]);
                                  coffeeViewModel.getAllMenus();
                                }else{
                                  coffeeViewModel.menus.onUpdateData([]);
                                  coffeeViewModel.getAllMenusByCoffeeShopID(shops[index].id ?? "");
                                }
                                setState(() {
                                  _index = index;
                                });
                              },
                              child: Card(
                                elevation: 5,
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(70),
                                  borderSide: BorderSide.none
                                ),
                                color: _index == index ? AppColors.kBackgroundColor : AppColors.kWhiteColor,
                                child: Container(
                                  width: 80.sp,
                                  padding: EdgeInsets.all(5.0.sp),
                                  child: Column(
                                    children: [
                                      AppSize.h5.ph,
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(70),
                                        child: Image.network(
                                          shops[index].logo ?? "",
                                          height: 60.sp,
                                          width: 40.sp,
                                          fit: index == 0 ? BoxFit.fitHeight : BoxFit.cover,
                                        ),
                                      ),
                                      AppSize.h10.ph,
                                      Text( shops[index].name ?? "",
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: AppStyles.kTextStyle10.copyWith(
                                        color: AppColors.kBlackCColor
                                      ),),
                                      AppSize.h5.ph,
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index){
                            return AppSize.h10.pw;
                          },
                          itemCount: shops.length
                      ),
                    );
                }
              ),
             */

              BlocBuilder<GenericCubit<List<Category>>, GenericCubitState<List<Category>>>(
                  bloc: adminHomeViewModel.allCategories,
                  builder:  (context, state) {
                    List<Category> shops =  state.data;
                    return state is GenericLoadingState ?
                    const SizedBox():
                    Column(
                      children: [
                        InkWell(
                          onTap:(){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context){
                                  return ShowAllCategory(cats: state.data, adminHomeViewModel: adminHomeViewModel, coffeeViewModel: coffeeViewModel,);
                                })
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Top Categories", style: AppStyles.kTextStyleHeader20,),
                              Row(
                                children: [
                                  Text("View All", style: AppStyles.kTextStyleHeader16.copyWith(
                                      color: AppColors.kFogColor
                                  ),),
                                  Icon(Icons.arrow_right_rounded, size: 25.sp,)
                                ],
                              ),
                            ],
                          ),
                        ),
                        AppSize.h10.ph,
                        Container(
                          height: 130.sp,
                          child: ListView.separated(scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index){
                                 return InkWell(
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context){
                                          return ShowAllMenusBasedonCategory(category: shops[index], coffeeViewModel: coffeeViewModel,);
                                        })
                                    );
                                  },
                                  child: Card(
                                    elevation: 5,
                                    shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(70),
                                      borderSide: BorderSide.none
                                    ),
                                    color: AppColors.kWhiteColor,
                                    child: Container(
                                      width: 80.sp,
                                      padding: EdgeInsets.all(5.0.sp),
                                      child: Column(
                                        children: [
                                          AppSize.h5.ph,
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(70),
                                            child: Image.network(
                                              "https://firebasestorage.googleapis.com/v0/b/coffe-80f60.appspot.com/o/unsplash_L-sm1B4L1Ns.png?alt=media&token=1905fffb-a2ac-4f14-89a9-f354c2f9e4fc",
                                              height: 60.sp,
                                              width: 40.sp,
                                              fit: index == 0 ? BoxFit.fitHeight : BoxFit.cover,
                                            ),
                                          ),
                                          AppSize.h10.ph,
                                          Text( shops[index].name ?? "",
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: AppStyles.kTextStyle10.copyWith(
                                            color: AppColors.kBlackCColor
                                          ),),
                                          AppSize.h5.ph,
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index){
                                return AppSize.h10.pw;
                              },
                              itemCount: shops.length
                          ),
                        ),
                      ],
                    );
                }
              ),
              AppSize.h20.ph,
              BlocBuilder<GenericCubit<List<CoffeeShope>>, GenericCubitState<List<CoffeeShope>>>(
                  bloc: homeViewModel.allCoffeeShopes,
                  builder:  (context, state) {
                    List<CoffeeShope> shops =  state.data;
                    // shops.add(CoffeeShope(
                    //     id: "0",
                    //     name: "All Coffees",
                    //     logo: "https://firebasestorage.googleapis.com/v0/b/coffe-80f60.appspot.com/o/all-inclusive.png?alt=media&token=539c0afc-2464-4d96-913e-807e69848ece"
                    // ));
                    // state.data.forEach((e){
                    //   shops.add(e);
                    // });
                    return state is GenericLoadingState ?
                    const SizedBox():
                    Column(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context){
                                  return ShowAllCoffees(coffees: shops, coffeeViewModel: coffeeViewModel,);
                                })
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Featured Coffee Shops", style: AppStyles.kTextStyleHeader20,),
                              Row(
                                children: [
                                  Text("View All", style: AppStyles.kTextStyleHeader16.copyWith(
                                      color: AppColors.kFogColor
                                  ),),
                                  Icon(Icons.arrow_right_rounded, size: 25.sp,)
                                ],
                              ),
                            ],
                          ),
                        ),
                        ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index){
                              double ran = (1 + random.nextInt(20)).toDouble();
                              double star = (1 + random.nextInt(5)).toDouble();
                              return InkWell(
                                onTap: (){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context){
                                        return ShowAllMenus(coffeeShope: shops[index], coffeeViewModel: coffeeViewModel,);
                                      })
                                  );
                                  // if(shops[index] == "0"){
                                  //   coffeeViewModel.allMenus.onUpdateData([]);
                                  //   coffeeViewModel.getAllMenus();
                                  // }else{
                                  //   coffeeViewModel.menus.onUpdateData([]);
                                  //   coffeeViewModel.getAllMenusByCoffeeShopID(shops[index].id ?? "");
                                  // }
                                  // setState(() {
                                  //   _index = index;
                                  // });
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
                                            shops[index].logo ?? "",
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
                                              Text(shops[index].name ?? "",
                                                maxLines: 2,
                                                style: AppStyles.kTextStyleHeader18.copyWith(
                                                    color: AppColors.kBlackCColor,
                                                  fontWeight: FontWeight.bold
                                                ),),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(star.toString(),
                                                    maxLines: 2,
                                                    style: AppStyles.kTextStyleHeader12.copyWith(
                                                        color: AppColors.kBlackCColor
                                                    ),),
                                                  AppSize.h5.pw,
                                                  Image.asset(Resources.rate_calc, height: 20.sp, color: AppColors.kBackgroundColor,),
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
                            itemCount: shops.length
                        ),
                      ],
                    );
                  }
              ),
              AppSize.h20.ph,

              // BlocBuilder<GenericCubit<List<Menu>>, GenericCubitState<List<Menu>>>(
              //     bloc: _index == 0? coffeeViewModel.allMenus : coffeeViewModel.menus,
              //     builder:  (context, state) {
              //       var menus = state.data;
              //       return state is GenericLoadingState ?
              //       const Loading(): MenuPage(menu: menus);
              //   }
              // )
            ],
          ),
        ),
      ),
    );
  }
}