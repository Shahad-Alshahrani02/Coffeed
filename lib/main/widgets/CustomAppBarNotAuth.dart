import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/util/ui.dart';

AppBar customAppBarWithoutBack(BuildContext context, {String? title}) {
  return AppBar(
    backgroundColor: AppColors.kWhiteColor,
    elevation: 0,
    leading: InkWell(
      onTap: () => UI.pop(),
      child: Icon(Icons.arrow_back_ios_rounded),
    ),
    shape: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40)
      )
    ),
    centerTitle: true,
    title: Text(
        title ?? 'Welcome To Coffee',
      style: AppStyles.kTextStyleHeader22.copyWith(
        fontWeight: FontWeight.bold
      ),
    ),
  );
}

