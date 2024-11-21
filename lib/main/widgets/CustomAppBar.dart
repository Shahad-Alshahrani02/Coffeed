import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';

AppBar customAppBar(String title, BuildContext context) {
  return AppBar(
    backgroundColor: AppColors.kFogColor,
    shape: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40)
        )
    ),
    centerTitle: true, // Center the title
    elevation: 0,
    title: Text(
      title,
      style: AppStyles.kTextStyle22.copyWith(fontWeight: FontWeight.bold, color: AppColors.kBlackColor),
    ),
  );
}