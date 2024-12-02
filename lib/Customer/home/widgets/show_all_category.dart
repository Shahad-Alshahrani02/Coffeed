import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/Customer/cart/widgets/CartIconWidget.dart';
import 'package:template/features/Customer/home/widgets/show_all_menus_basedon_category.dart';
import 'package:template/features/admin/home/admin_home_viewModel.dart';
import 'package:template/features/admin/home/models/Category.dart';
import 'package:template/features/coffee/coffees/coffee_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/util/ui.dart';

class ShowAllCategory extends StatelessWidget {
  final List<Category> cats;
  final AdminHomeViewModel adminHomeViewModel;
  final CoffeeViewModel coffeeViewModel;
  const ShowAllCategory({Key? key, required this.cats, required this.adminHomeViewModel, required this.coffeeViewModel}) : super(key: key);

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
        title: Text("All Categories", style: AppStyles.kTextStyleHeader26,),
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
                  controller: adminHomeViewModel.search,
                prefix: Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: Image.asset(Resources.search, height: 20.sp, width: 20.sp, fit: BoxFit.fill,),
                ),
              ),
            ),

            AppSize.h20.ph,

            Wrap(
              children: List.generate(cats.length, (index){
                return InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context){
                          return ShowAllMenusBasedonCategory(category: cats[index], coffeeViewModel: coffeeViewModel,);
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
                              borderRadius: BorderRadius.circular(70),
                              child: Image.network(
                                cats[index].image ?? "https://firebasestorage.googleapis.com/v0/b/coffe-80f60.appspot.com/o/unsplash_L-sm1B4L1Ns.png?alt=media&token=1905fffb-a2ac-4f14-89a9-f354c2f9e4fc",
                                height: 60.sp,
                                width: 40.sp,
                                fit:  BoxFit.cover,
                              ),
                            ),
                            AppSize.h10.ph,
                            Text( cats[index].name ?? "",
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
