

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:template/features/Customer/cart/models/CartItem.dart';
import 'package:template/features/Customer/cart/cart_viewModel.dart';
import 'package:template/features/Customer/orders/models/order.dart';
import 'package:template/features/Customer/payment/SelectPaymentWay.dart';
import 'package:template/features/Customer/payment/VisaCardPaymentPage.dart';
import 'package:template/features/coffee/coffees/models/menu.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBar.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      body: Padding(
        padding: EdgeInsets.only(top: 100.0.sp, left: 10.sp, right: 10.sp, bottom: 20.sp,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("My Order", style: AppStyles.kTextStyleHeader20,),
            Expanded(
                child: Provider.of<CartViewModel>(context, listen: false).items.isEmpty?
                const EmptyData():
                ListView.builder(
                  itemCount:  Provider.of<CartViewModel>(context, listen: false).items.length,
                  itemBuilder: (context, index) {
                    final item =  Provider.of<CartViewModel>(context, listen: false).items[index];
                    return _buildCartItem(item);
                    },
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Total Price',
                      style: AppStyles.kTextStyleHeader18,
                    ), Text(
                      '${Provider.of<CartViewModel>(context, listen: false).totalPrice.toStringAsFixed(2)} R.S',
                      style: AppStyles.kTextStyle20.copyWith(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
                  bloc: Provider.of<CartViewModel>(context, listen: false).loading,
                  builder: (context, state) {
                    return state.data? const Loading():
                        InkWell(
                          onTap: (){
                            // Navigator.of(context).push(
                            //     MaterialPageRoute(builder: (context) => VisaCardPaymentPage())
                            // );

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(AppSize.r30),
                                  topRight: Radius.circular(AppSize.r30),
                                ),
                              ),
                              builder: (_) => SelectPaymentWay(),
                            );

                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.kRateColor
                            ),
                            height: 50.sp,
                            width: 150.sp,
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.sp),
                              child: Image.asset(Resources.cart, height: 25.sp, color: AppColors.kWhiteColor,),
                            ),
                          ),
                        );
                    // CustomButton(
                    //     title: "Checkout",
                    //     width: 200.sp,
                    //     btnColor: AppColors.kFogColor,
                    //     radius: 30,
                    //     onClick: (){
                    //       Navigator.of(context).push(
                    //         MaterialPageRoute(builder: (context) => VisaCardPaymentPage())
                    //       );
                    //     });
                  }
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () => UI.pop(),
                    child: Icon(Icons.arrow_back_outlined))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItemValue item) {
    return Dismissible(
      onDismissed: (d) async {
        Provider.of<CartViewModel>(context, listen: false).removeFromCart(item.product ?? Menu());
      },
      direction: DismissDirection.endToStart, // Swipe left to reveal delete icon
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.redAccent,
        child: GestureDetector(
          onTap: () {
          },
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      // confirmDismiss: (direction) async {
      //   // Show dialog or custom confirmation logic here if needed
      //   return false; // Prevent dismissal by swiping
      // },

      key: UniqueKey(),
      child: Card(
        color: AppColors.kSearchColor,
        child: Padding(
          padding: EdgeInsets.all(15.sp),
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(item.product?.image ?? "", width: 60.sp, height: 70.sp, fit: BoxFit.cover,)),
              SizedBox(width: 10.sp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.product?.name ?? "", style: AppStyles.kTextStyleHeader16),
                    Text('${item.product?.newPrice?.toStringAsFixed(2)} R.S', style: AppStyles.kTextStyleHeader13,),
                    Row(
                      children: [
                        GestureDetector(
                          child: Icon(Icons.remove),
                          onTap: () {
                            setState(() {
                              item.decrement();
                              if (item.quantity == 0) {
                                Provider.of<CartViewModel>(context, listen: false).removeFromCart(item.product ?? Menu());
                              }
                            });
                          },
                        ),
                        AppSize.h10.pw,
                        Text('${item.quantity}', style: AppStyles.kTextStyle20),
                        AppSize.h10.pw,
                        GestureDetector(
                          child: Icon(Icons.add),
                          onTap: () {
                            setState(() {
                              item.increment();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.sp),
              Text('${(item.product!.newPrice! * item.quantity).toStringAsFixed(2)} R.S', style: AppStyles.kTextStyle16),
            ],
          ),
        ),
      ),
    );
  }
}
