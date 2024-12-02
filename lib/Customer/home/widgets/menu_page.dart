import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/Customer/home/widgets/show_menu_details.dart';
import 'package:template/features/Customer/home/widgets/show_rate_details.dart';
import 'package:template/features/coffee/coffees/models/menu.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/empty_page.dart';

class MenuPage extends StatefulWidget {
  final List<Menu> menu;
  const MenuPage({Key? key, required this.menu}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.menu.isEmpty?
            const EmptyData():
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  var menu = widget.menu.elementAt(index);
                  return InkWell(
                    onTap: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ShowMenuDetails(menu: menu,)));
                    },
                    child: Card(
                      color: AppColors.kWhiteColor,
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.all(10.sp),
                        width: 220.sp,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                menu.image ?? "",
                                height: 120.sp,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            ),
                            AppSize.h10.ph,
                            Row(
                              children: [
                                Expanded(child: Text(menu.name ?? "", style: AppStyles.kTextStyleHeader13.copyWith(
                                    fontWeight: FontWeight.bold
                                ),)),
                                Row(
                                  children: [
                                    Text(menu.newPrice.toString() ?? "", style: AppStyles.kTextStyle20.copyWith(
                                      fontWeight: FontWeight.bold
                                    ),),
                                    AppSize.h5.pw,
                                    Text("R.S", style: AppStyles.kTextStyleHeader20,)
                                  ],
                                )
                              ],
                            ),
                            AppSize.h10.ph,
                            Row(
                              children: [
                                PrefManager.currentUser?.type == 3?
                                const Expanded(child: SizedBox()):
                                Expanded(child: Text(menu.description ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                AppSize.h10.pw,
                                Row(
                                  children: [
                                    PrefManager.currentUser?.type == 2?
                                    IconButton(
                                        onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ShowMenuDetails(menu: menu,)));
                                          },
                                        icon: Icon(Icons.shopping_cart_rounded,
                                          size: 30.sp,
                                          color: Colors.black54,
                                        )
                                    ): const SizedBox(),
                                    IconButton(onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ShowRateDetails(menu: menu,)));
                                    },
                                        icon: Image.asset(Resources.star, height: 25.sp, color: AppColors.kFogColor,),
                                    )
                                  ],
                                )
                              ],
                            ),
                            AppSize.h5.ph,
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index){
                  return AppSize.h5.pw;
                },
                itemCount: widget.menu.length
            ),
          ],
        ),
    );
  }
}
