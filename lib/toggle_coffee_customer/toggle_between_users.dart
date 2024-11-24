import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/register/coffee_register_page.dart';
import 'package:template/features/authentication/register/customer_register_page.dart';
import 'package:template/features/toggleBetweenUsers/background_page.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';

class ToggleBetweenUsers extends StatefulWidget {
  const ToggleBetweenUsers({Key? key}) : super(key: key);

  @override
  State<ToggleBetweenUsers> createState() => _ToggleBetweenUsersState();
}

class _ToggleBetweenUsersState extends State<ToggleBetweenUsers> {
  bool isShopOwner = false;
  bool isCustomer = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("Welcome To Cuppa!", style: AppStyles.kTextStyleHeader22,),
        ),
        body: BackgroundPage(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50.sp),
                child: Container(
                  color: AppColors.kWhiteColor,
                  child: Column(
                    children: [
                      AppSize.h20.ph,
                      Text("Register", style: AppStyles.kTextStyleHeader20,),
                      AppSize.h15.ph,
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 20.sp),
                        child: Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: isShopOwner,
                                title: Text("Shop Owner", style: AppStyles.kTextStyle14,),
                                onChanged: (bool? value) {
                                  setState(() {
                                    isShopOwner = value ?? false;
                                    isCustomer = !(value ?? false);

                                  });
                                },
                              ),
                            ),

                            Expanded(
                              child: CheckboxListTile(
                                value: isCustomer,
                                title: Text("Customer", style: AppStyles.kTextStyle14,),
                                onChanged: (bool? value) {
                                  setState(() {
                                    isCustomer = value ?? false;
                                    isShopOwner = !(value ?? false);

                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      AppSize.h15.ph,
                      isCustomer? const Expanded(child: CustomerRegisterPage()):
                      const Expanded(child: CoffeeRegisterPage()),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child:  InkWell(
                  onTap: () => UI.pop(),
                  child: Container(
                    height: 90.sp,
                    width: 60.sp,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppColors.kBackgroundColor
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.sp),
                      child: RotatedBox(quarterTurns: 2,child: Image.asset(Resources.up)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
