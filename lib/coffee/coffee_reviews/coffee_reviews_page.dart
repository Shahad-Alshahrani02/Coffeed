import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/Customer/home/widgets/menu_page.dart';
import 'package:template/features/coffee/coffees/coffee_viewModel.dart';
import 'package:template/features/coffee/coffees/models/menu.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class CoffeeReviewsPage extends StatefulWidget {
  const CoffeeReviewsPage({Key? key}) : super(key: key);

  @override
  State<CoffeeReviewsPage> createState() => _CoffeeReviewsPageState();
}

class _CoffeeReviewsPageState extends State<CoffeeReviewsPage> {
  CoffeeViewModel coffeeViewModel = CoffeeViewModel();
  
  @override
  void initState() {
    if(PrefManager.currentUser!.type == 1){
      coffeeViewModel.getAllMenus();
    } else {
      coffeeViewModel.getAllMenusByOwnerID(PrefManager.currentUser!.id!);
    }
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: AppColors.kWhiteColor,
        title: Text("Ratings", style: AppStyles.kTextStyleHeader20,),
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
      body: Container(
        margin: EdgeInsets.all(20.sp),
        padding: EdgeInsets.only(bottom: 100.sp),
        child: BlocBuilder<GenericCubit<List<Menu>>, GenericCubitState<List<Menu>>>(
            bloc: PrefManager.currentUser!.type == 1 ? coffeeViewModel.allMenus: coffeeViewModel.menus,
            builder:  (context, state) {
              var menus = state.data;
              return state is GenericLoadingState ?
              const Loading(): MenuPage(menu: menus);
            }
        ),
      ),
    );
  }
}
