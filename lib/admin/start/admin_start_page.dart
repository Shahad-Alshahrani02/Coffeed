
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/Customer/cart/cart_viewModel.dart';
import 'package:template/features/admin/home/admin_home_page.dart';
import 'package:template/features/admin/start/admin_start_viewModel.dart';
import 'package:template/features/authentication/profile_page.dart';
import 'package:template/features/coffee/advertisment/ShowAdminAdvertisment.dart';
import 'package:template/features/coffee/coffee_reviews/coffee_reviews_page.dart';
import 'package:template/features/customer/home/home_page.dart';
import 'package:template/features/customer/orders/order_page.dart';
import 'package:template/features/customer/start/customer_start_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:provider/provider.dart';

GlobalKey<ScaffoldState> startScaffoldKey = GlobalKey();

class AdminStartPage extends StatefulWidget {
  const AdminStartPage({Key? key}) : super(key: key);

  @override
  State<AdminStartPage> createState() => _AdminStartPageState();
}

class _AdminStartPageState extends State<AdminStartPage> {
  AdminStartViewModel startViewModel = AdminStartViewModel();

  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      const AdminHomePage(),
      const CoffeeReviewsPage(),
      const ShowAdminAdvertisment(),
      const ProfilePage()
    ];
    super.initState();
  }


  late NavigatorState _navigator;

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  NavigatorState of(BuildContext context, {bool rootNavigator = false}) {
    NavigatorState? navigator;
    if (context is StatefulElement && context.state is NavigatorState) {
      navigator = context.state as NavigatorState;
    }
    if (rootNavigator) {
      navigator =
          context.findRootAncestorStateOfType<NavigatorState>() ?? navigator;
    } else {
      navigator =
          navigator ?? context.findAncestorStateOfType<NavigatorState>();
    }
    return navigator!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<int>, GenericCubitState<int>>(
      bloc: startViewModel.currentPageCubit,
      builder: (context, state) {
        return Provider(
          create: (_) => CartViewModel(),
          child: Scaffold(
            key: startScaffoldKey,
            body: pages[state.data],
            backgroundColor: AppColors.kWhiteColor,
            bottomSheet: Container(
              height: AppSize.navBarHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.kBackgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Material(
                shadowColor: AppColors.kWhiteColor,
                elevation: 100,
                color: AppColors.kFogColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildBottomNavItem(Resources.menu, "Home", 0, state.data),
                      buildBottomNavItem(Resources.star, "My Coffee", 1, state.data),
                      buildBottomNavItem(Resources.advertise, "Adverts", 2, state.data),
                      buildBottomNavItem(Resources.user, "Profile", 3, state.data)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildBottomNavItem(String icon, String label, int index, int currentState) {
    return InkWell(
      onTap: () {
        startViewModel.currentPageCubit.onUpdateData(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, color: currentState == index ? AppColors.kBlackColor : AppColors.kWhiteColor, height: 25.sp,width: 25.sp,),
          AppSize.h5.ph,
          Text(
            label,
            style: AppStyles.kTextStyle12.copyWith(
              color: currentState == index ? AppColors.kBlackColor : AppColors.kWhiteColor,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }
}