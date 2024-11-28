
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/Customer/cart/cart_page.dart';
import 'package:template/features/Customer/home/home_page.dart';
import 'package:template/features/Customer/maps/maps_page.dart';
import 'package:template/features/Customer/more/more.dart';
import 'package:template/features/Customer/orders/order_page.dart';
import 'package:template/features/Customer/orders/order_timeline_page.dart';
import 'package:template/features/Customer/start/customer_start_viewModel.dart';
import 'package:template/features/authentication/profile_page.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';


GlobalKey<ScaffoldState> startScaffoldKey = GlobalKey();

class CustomerStartPage extends StatefulWidget {
  const CustomerStartPage({Key? key}) : super(key: key);

  @override
  State<CustomerStartPage> createState() => _CustomerStartPageState();
}

class _CustomerStartPageState extends State<CustomerStartPage> {
  CustomerStartViewModel startViewModel = CustomerStartViewModel();

  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      const HomePage(),
      OrderTimelinePage(),
      const MapsPage(),
      const MorePage()
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
        return Scaffold(
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
              color: AppColors.kWhiteColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildBottomNavItem(Resources.home, 0, state.data),
                    buildBottomNavItem(Resources.order1, 1, state.data),
                    buildBottomNavItem(Resources.location, 2, state.data),
                    buildBottomNavItem(Resources.user, 3, state.data)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildBottomNavItem(String icon, int index, int currentState) {
    return InkWell(
      onTap: () {
        startViewModel.currentPageCubit.onUpdateData(index);
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentState == index ? AppColors.kBackgroundColor : null
        ),
          height: 35.sp,width: 35.sp,
          padding: EdgeInsets.all(7.5.sp),
          child: Image.asset(icon, color: AppColors.kBlackColor, height: 20.sp,width: 20.sp,)),
    );
  }
}