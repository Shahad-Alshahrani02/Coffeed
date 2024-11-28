import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';

class OrderCompletedWidget extends StatelessWidget {
  const OrderCompletedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 100.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Resources.done_order, height: 150.sp,),
            AppSize.h20.ph,
            Text("Ordered", style: AppStyles.kTextStyleHeader20,),
            
            AppSize.h30.ph,
            Text("${PrefManager.currentUser?.name ?? ""}, your order has been placed successfully.",
              textAlign: TextAlign.center,
              style: AppStyles.kTextStyle20.copyWith(
              color: AppColors.kGreyColor
            ),),

            AppSize.h30.ph,
            Text("The order will be ready", style: AppStyles.kTextStyle16.copyWith(
              fontWeight: FontWeight.bold
            ),),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(20.sp),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        UI.pushWithRemove(AppRoutes.customerStartPage);
                      },
                      child: Icon(Icons.arrow_back_outlined))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
