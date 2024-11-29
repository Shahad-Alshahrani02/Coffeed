import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/extentions/padding_extentions.dart';

class ProfileItem extends StatelessWidget {
  final TextStyle style;
  final String? value;
  final String? image;
  const ProfileItem(this.style, this.value,this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(value == null){
      return AppSize.h1.ph;
    }else{
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColors.kMainColor)
              )
          ),
          child: Row(
            children: [
              Image.asset(image ?? "", height: 25.sp, width: 25.sp,),
              AppSize.h16.pw,
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.sp),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.kBlackColor)
                  ),
                ),
              ),
              AppSize.h16.pw,
              Expanded(
                child: Text(
                  value ?? 'Not available',
                  style: style,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
