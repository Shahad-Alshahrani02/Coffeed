import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/admin/home/admin_home_viewModel.dart';
import 'package:template/features/admin/home/models/Category.dart';
import 'package:template/features/admin/home/widgets/AddCategory.dart';
import 'package:template/features/admin/home/widgets/DashboardPage.dart';
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
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  AdminHomeViewModel viewModel = AdminHomeViewModel();
  CoffeeViewModel coffeeViewModel = CoffeeViewModel();
  AdvertismentViewModel advertismentViewModel = AdvertismentViewModel();
  HomeViewModel homeViewModel = HomeViewModel();


  @override
  void initState() {
    viewModel.getAllCategories();
    homeViewModel.getAllCoffeeShops();
    coffeeViewModel.getAllMenus();
    advertismentViewModel.getAllAdvertisements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(title: "Home", context),
      body: Container(
        padding: EdgeInsets.all(10.sp),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 80.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<GenericCubit<List<Advertisment>>, GenericCubitState<List<Advertisment>>>(
                  bloc: advertismentViewModel.allAdvertisments,
                  builder:  (context, allAdvertisments) {
                    return allAdvertisments is GenericLoadingState ?
                    const Loading() :
                    BlocBuilder<GenericCubit<List<CoffeeShope>>, GenericCubitState<List<CoffeeShope>>>(
                      bloc: homeViewModel.allCoffeeShopes,
                      builder: (context, coffeeShops) {
                        return BlocBuilder<GenericCubit<List<Menu>>, GenericCubitState<List<Menu>>>(
                          bloc: coffeeViewModel.allMenus,
                          builder:  (context, menus) {
                            return menus is GenericLoadingState ?
                            const Loading(): BlocBuilder<GenericCubit<List<Category>>, GenericCubitState<List<Category>>>(
                              bloc: viewModel.allCategories,
                              builder:  (context, cats) {
                                return cats is GenericLoadingState ?
                                const Loading(): DashboardPage(
                                  menuItemsCount: menus.data.length,
                                  categoriesCount: cats.data.length,
                                  coffeesCount: coffeeShops.data.length,
                                  advertisementsCount: allAdvertisments.data.length
                              );
                            }
                          );
                        }
                      );
                    }
                  );
                }
              ),
              
              AppSize.h10.ph,
              
              Row(
                children: [
                  Expanded(child: Text("All Categories", style: AppStyles.kTextStyleHeader20,)),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AddCategory(viewModel: viewModel)));
                    },
                    child: Card(
                      color: AppColors.kFogColor,
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(10.0.sp),
                        child: Row(
                          children: [
                            Text("New", style: AppStyles.kTextStyleHeader16.copyWith(
                                fontWeight: FontWeight.bold
                            ),),
                            AppSize.h10.pw,
                            Icon(Icons.add_circle_outline_sharp),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              BlocBuilder<GenericCubit<List<Category>>, GenericCubitState<List<Category>>>(
                  bloc: viewModel.allCategories,
                  builder:  (context, state) {
                    var cats = state.data;
                    return state is GenericLoadingState ?
                    const SizedBox(): ListView.builder(
                      itemCount: cats.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          color: AppColors.kWhiteColor,
                          child: Padding(
                            padding: EdgeInsets.all(10.sp),
                            child: Text(cats[index].name ?? "", style: AppStyles.kTextStyleHeader16,),
                          ),
                        );
                      }
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


