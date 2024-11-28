import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/Customer/cart/models/CartItem.dart';  // Assuming CartItemValue is part of this file
import 'package:template/features/Customer/orders/models/order.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class InvoicePage extends StatelessWidget {
  final OrderItem orderItem;

  InvoicePage({required this.orderItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice Details", style: AppStyles.kTextStyleHeader20,),
        leading: InkWell(
          onTap: () => UI.pop(),
          child: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      backgroundColor: AppColors.kSearchColor,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              color: AppColors.kWhiteColor
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order ID: ${orderItem.id}",
                  style: AppStyles.kTextStyleHeader16,
                ),
                SizedBox(height: 10.sp),
                Text("Name: ${orderItem.user?.name}", style: AppStyles.kTextStyle16,),
                SizedBox(height: 10.sp),
                Text("Address: ${orderItem.user?.address}",style: AppStyles.kTextStyle16,),
                SizedBox(height: 10.sp),
                Text("Status: ${orderItem.status}",style: AppStyles.kTextStyle16,),
                SizedBox(height: 10.sp),
                Text("Comment: ${orderItem.comment ?? 'No comment provided'}",style: AppStyles.kTextStyle18,),
                SizedBox(height: 20),

              ],
            ),
          ),
          AppSize.h16.ph,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Text(
              "Menu Items",
              style: AppStyles.kTextStyleHeader20
            ),
          ),
          SizedBox(height: 10),
          // List of Cart Items
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(10.sp),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderItem.cartItem?.length ?? 0,
            itemBuilder: (context, index) {
              final cartItem = orderItem.cartItem![index];
              return Card(
                color: AppColors.kWhiteColor,
                margin: EdgeInsets.only(bottom: 10.sp),
                child: ListTile(
                  leading: cartItem.product?.image != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                        child: Image.network(cartItem.product!.image!,
                                            height: 500.sp,
                                            width: 70.sp,
                                            fit: BoxFit.cover,
                                          ),
                      ) : Icon(Icons.shopping_cart),
                  title: Text(cartItem.product?.name ?? 'Unnamed Product'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: R.S${cartItem.product?.newPrice.toString()}'),
                      Text('Quantity: ${cartItem.quantity.toString()}'),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      Text('Total'),
                      Text(
                        'R.S${(cartItem.product!.newPrice! * cartItem.quantity).toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          AppSize.h16.ph,
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.sp),
            margin: EdgeInsets.all(10.0.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: AppColors.kSecondryColor
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Price", style: AppStyles.kTextStyle24.copyWith(
                    fontWeight: FontWeight.bold,
                  color: AppColors.kWhiteColor
                )),
                Text("${_calculateTotal(orderItem.cartItem ?? [])} R.S", style: AppStyles.kTextStyle20.copyWith(
                    color: AppColors.kWhiteColor,
                    fontWeight: FontWeight.bold
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotal(List<CartItemValue> cartItems) {
    return cartItems.fold(0, (sum, item) => sum + item.product!.newPrice! * item.quantity);
  }
}
