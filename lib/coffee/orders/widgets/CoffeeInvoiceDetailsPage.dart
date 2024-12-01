import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:template/features/Customer/cart/models/CartItem.dart';  // Assuming CartItemValue is part of this file
import 'package:template/features/Customer/orders/models/order.dart';
import 'package:template/features/coffee/advertisment/models/advertisment.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class CoffeeInvoiceDetailsPage extends StatelessWidget {
  const CoffeeInvoiceDetailsPage({Key? key, required this.orderItem}) : super(key: key);
  final Advertisment orderItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        title: Text("Payment Details", style: AppStyles.kTextStyleHeader20,),
        centerTitle: true,
        leading: InkWell(
          onTap: () => UI.pop(),
          child: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      backgroundColor: AppColors.kWhiteColor,
      body: ListView(
        children: [
          Divider(),
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
                  "Ad ID: ${orderItem.id}",
                  style: AppStyles.kTextStyleHeader16,
                ),
                SizedBox(height: 10.sp),
                Text("Name: ${orderItem.title}", style: AppStyles.kTextStyle16,),
                SizedBox(height: 10.sp),
                Text("Address: ${orderItem.coffeeShopData?.location}",style: AppStyles.kTextStyle16,),
                SizedBox(height: 10.sp),
                Text("Status: ${orderItem.isApporved == null ? "Pending": orderItem.isApporved! ? "Accepted": "Rejected"}",style: AppStyles.kTextStyle16,),
                SizedBox(height: 20.sp),

              ],
            ),
          ),
          AppSize.h16.ph,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Text(
                "Ad Details",
                style: AppStyles.kTextStyleHeader20
            ),
          ),
          SizedBox(height: 10),
          // List of Cart Items
          Card(
            color: AppColors.kWhiteColor,
            margin: EdgeInsets.only(bottom: 10.sp),
            child: ListTile(
              leading: orderItem.image != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(orderItem.image!,
                  height: 500.sp,
                  width: 70.sp,
                  fit: BoxFit.cover,
                ),
              ) : Icon(Icons.shopping_cart),
              title: Text(orderItem.title ?? 'Unnamed Product'),
              subtitle: Text('Price: ${orderItem.price.toString()}R.S'),
              trailing: Column(
                children: [
                  Text(
                    'Start date: ${DateFormat("y MMM d").format(orderItem.startDate ?? DateTime.now())}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'End date: ${DateFormat("y MMM d").format(orderItem.endDate ?? DateTime.now())}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
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
                Text("${orderItem.price} R.S", style: AppStyles.kTextStyle20.copyWith(
                    color: AppColors.kWhiteColor,
                    fontWeight: FontWeight.bold
                )),
              ],
            ),
          ),
          AppSize.h16.ph,

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 110.sp),
            child: CustomButton(
                title: "pay",
                width: 100.sp,
                radius: 40,
                btnColor: AppColors.kSecondryColor,
                onClick: (){
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSize.r30),
                        topRight: Radius.circular(AppSize.r30),
                      ),
                    ),
                    builder: (_) => BuildPaymentAdvert(price: orderItem.price ?? 0.0,),
                  );
                }),
          )

        ],
      ),
    );
  }

  double _calculateTotal(List<CartItemValue> cartItems) {
    return cartItems.fold(0, (sum, item) => sum + item.product!.newPrice! * item.quantity);
  }
}

class BuildPaymentAdvert extends StatefulWidget {
  final double price;
  const BuildPaymentAdvert({Key? key, required this.price}) : super(key: key);

  @override
  State<BuildPaymentAdvert> createState() => _BuildPaymentAdvertState();
}

class _BuildPaymentAdvertState extends State<BuildPaymentAdvert> {
  int? _selectedOption = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: AppSize.h723,
        width: double.infinity,
        padding: EdgeInsets.all(AppSize.w26),
        decoration: BoxDecoration(
          color: AppColors.kWhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSize.r30),
            topRight: Radius.circular(AppSize.r30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order payment", style: AppStyles.kTextStyle20,),
            AppSize.h20.ph,
            Card(
              color: AppColors.kSearchColor,
              child: Padding(
                padding: EdgeInsets.all(10.sp),
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<int>(
                        title: Text("Apple Pay"),
                        value: 1,
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value;
                          });
                        },
                      ),
                    ),
                    Image.asset(Resources.pay, height: 35.sp,)
                  ],
                ),
              ),
            ),
            AppSize.h10.ph,
            Card(
              color: AppColors.kSearchColor,
              child: Padding(
                padding: EdgeInsets.all(10.sp),
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<int>(
                        title: Text("Credit Card"),
                        subtitle: Text("2540 xxxx xxxx 2648"),
                        value: 2,
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value;
                          });
                        },
                      ),
                    ),
                    Image.asset(Resources.visa, height: 13.sp,),
                    Image.asset(Resources.mada, height: 45.sp,),
                  ],
                ),
              ),
            ),
            AppSize.h10.ph,
            Card(
              color: AppColors.kSearchColor,
              child: Padding(
                padding: EdgeInsets.all(10.sp),
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<int>(
                        title: Text("STC Pay"),
                        value: 3,
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value;
                          });
                        },
                      ),
                    ),
                    Image.asset(Resources.stc, height: 35.sp,)
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Total Price',
                      style: AppStyles.kTextStyleHeader18,
                    ), Text(
                      '${widget.price} R.S',
                      style: AppStyles.kTextStyle20.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: (){
                    UI.pushWithRemove(AppRoutes.coffeeStartPage);
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
                )
              ],
            ),
            Row(
              children: [
                InkWell(
                    onTap: () {
                      UI.pop();
                    },
                    child: Icon(Icons.arrow_back_outlined))
              ],
            )
          ],
        ),
      ),
    );
  }
}

