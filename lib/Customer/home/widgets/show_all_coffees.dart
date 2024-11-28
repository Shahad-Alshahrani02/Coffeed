import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/Customer/cart/widgets/CartIconWidget.dart';
import 'package:template/features/Customer/home/widgets/show_all_menus.dart';
import 'package:template/features/coffee/coffees/coffee_viewModel.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/util/ui.dart';

class ShowAllCoffees extends StatelessWidget {
  final List<CoffeeShope> coffees;
  final CoffeeViewModel coffeeViewModel;
  const ShowAllCoffees({Key? key, required this.coffees, required this.coffeeViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kBackgroundColor,
        leading: InkWell(
          onTap: () => UI.pop(),
          child: const Icon(Icons.arrow_back_ios_outlined),
        ),
        shape: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            )
        ),
        toolbarHeight: 100.sp,
        centerTitle: true,
        title: Text("All Coffee Shops", style: AppStyles.kTextStyleHeader26,),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            child: CartIconWidget(),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: CustomField(
                controller: coffeeViewModel.search,
                prefix: Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: Image.asset(Resources.search, height: 20.sp, width: 20.sp, fit: BoxFit.fill,),
                ),
              ),
            ),

            AppSize.h20.ph,

            Wrap(
              children: List.generate(coffees.length, (index){
                return InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context){
                          return ShowAllMenus(coffeeShope: coffees[index], coffeeViewModel: coffeeViewModel,);
                        })
                    );
                  },
                  child: SizedBox(
                    height: 160.sp,
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
                                coffees[index].logo ?? "",
                                height: 60.sp,
                                width: 60.sp,
                                fit: BoxFit.cover,
                              ),
                            ),
                            AppSize.h10.ph,
                            Text(coffees[index].name ?? "",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: AppStyles.kTextStyle16.copyWith(
                                  color: AppColors.kBlackCColor
                              ),),
                            AppSize.h5.ph,
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}