import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:template/features/Customer/cart/cart_viewModel.dart';
import 'package:template/features/Customer/cart/widgets/CartIconWidget.dart';
import 'package:template/features/Customer/orders/models/order.dart';
import 'package:template/features/Customer/rating/models/rating.dart';
import 'package:template/features/Customer/rating/rating_viewModel.dart';
import 'package:template/features/coffee/coffees/coffee_viewModel.dart';
import 'package:template/features/coffee/coffees/models/menu.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ShowMenuDetails extends StatefulWidget {
  final Menu menu;
  const ShowMenuDetails({Key? key, required this.menu}) : super(key: key);

  @override
  State<ShowMenuDetails> createState() => _ShowMenuDetailsState();
}

class _ShowMenuDetailsState extends State<ShowMenuDetails> {
  int size = 1;

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
        title: Text( widget.menu.name ?? "", style: AppStyles.kTextStyleHeader26,),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0),
            child: CartIconWidget(),
          )
        ],
      ),
      backgroundColor: AppColors.kBackgroundColor,
      body: Container(
        color: AppColors.kWhiteColor,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 250.sp,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(90),
                          bottomRight: Radius.circular(90)
                      ),
                    ),
                  ),

                  Container(
                    height: 200.sp,
                    decoration: BoxDecoration(
                      color: AppColors.kBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(120),
                          bottomRight: Radius.circular(120)
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    left: 10,
                    right: 10,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          widget.menu.image ?? "",
                          height: 250.sp,
                          width: 200.sp,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        size = 0;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(Resources.coffee_size, height: 50, color: size == 0 ? AppColors.kMainColor: null,),
                        AppSize.h10.ph,
                        Text("Small", style: AppStyles.kTextStyle14,)
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        size = 1;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(Resources.coffee_size, height: 70, color: size == 1 ? AppColors.kMainColor: null,),
                        AppSize.h10.ph,
                        Text("Medium", style: AppStyles.kTextStyle16,)
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        size = 2;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(Resources.coffee_size, height: 100, color: size == 2 ? AppColors.kMainColor: null,),
                        AppSize.h10.ph,
                        Text("Large", style: AppStyles.kTextStyle18,)
                      ],
                    ),
                  ),
                ],
              ),

              Container(
                color: AppColors.kWhiteColor,
                padding: EdgeInsets.all(10.sp),
                child: Column(
                  children: [
                    AppSize.h10.ph,
                    Row(
                      children: [
                        Text("Category: ", style: AppStyles.kTextStyle20,),
                        AppSize.h5.pw,
                        Text(widget.menu.categoryData?.name ?? "", style: AppStyles.kTextStyle16,),
                      ],
                    ),
                    AppSize.h5.ph,
                    Row(
                      children: [
                        Text("Coffee Shop: ", style: AppStyles.kTextStyle20,),
                        AppSize.h5.pw,
                        Text(widget.menu.coffeShopData?.name ?? "", style: AppStyles.kTextStyle16,),
                      ],
                    ),
                    AppSize.h30.ph,
                    Material(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.kTextFieldColor)
                      ),
                      child: CustomField(
                        controller: Provider.of<CartViewModel>(context, listen: false).comment,
                        hint: "Order Notes...",
                        maxLines: 4,
                        borderRaduis: 10,
                      ),
                    ),
                    AppSize.h20.ph,

                    Column(
                      children: [
                        widget.menu.poromotion == 0? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.menu.newPrice.toString() ?? "", style: AppStyles.kTextStyle20,),
                            AppSize.h5.pw,
                            Text("R.S", style: AppStyles.kTextStyleHeader20,)
                          ],
                        ): Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.menu.newPrice.toString() ?? "", style: AppStyles.kTextStyle14.copyWith(
                                decoration: TextDecoration.lineThrough
                            ),),
                            AppSize.h5.pw,
                            Text("R.S", style: AppStyles.kTextStyleHeader14,)
                          ],
                        ),
                        widget.menu.poromotion == 0?  SizedBox():
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text((widget.menu.newPrice).toString() ?? "", style: AppStyles.kTextStyle20,),
                            AppSize.h5.pw,
                            Text("R.S", style: AppStyles.kTextStyleHeader20,)
                          ],
                        ),
                      ],
                    ),
                    // Text(widget.menu.price.toString() + " RS", style: AppStyles.kTextStyle20.copyWith(
                    //   fontWeight: FontWeight.bold
                    // ),),
                    AppSize.h10.ph,
                    BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
                        bloc: Provider.of<CartViewModel>(context, listen: false).loading,
                        builder: (context, state) {
                          return state.data ?
                          const Loading():
                          CustomButton(
                            title: "Add to cart",
                            radius: 30,
                            width: 200.sp,
                            btnColor: AppColors.kBlackColor,
                            onClick: (){
                              Provider.of<CartViewModel>(context, listen: false).addToCart(widget.menu);
                            },
                          );
                        }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}