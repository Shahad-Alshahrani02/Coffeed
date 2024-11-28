import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:template/features/Customer/cart/cart_viewModel.dart';
import 'package:template/features/Customer/orders/models/order.dart';
import 'package:template/features/Customer/payment/VisaCardPaymentPage.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';

class SelectPaymentWay extends StatefulWidget {
  const SelectPaymentWay({Key? key}) : super(key: key);

  @override
  State<SelectPaymentWay> createState() => _SelectPaymentWayState();
}

class _SelectPaymentWayState extends State<SelectPaymentWay> {
  int? _selectedOption = 1;
  bool _selectedPaymentSlider= false;

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
              _selectedPaymentSlider ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppSize.h100.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Order payment", style: AppStyles.kTextStyle20,),
                          InkWell(
                              onTap: (){
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(AppSize.r30),
                                      topRight: Radius.circular(AppSize.r30),
                                    ),
                                  ),
                                  builder: (_) => const VisaCardPaymentPage(),
                                );
                              },
                              child: Text("+ Add New Card", style: AppStyles.kTextStyle14,)),
                        ],
                      ),
                      AppSize.h40.ph,

                      CarouselSlider(
                        options: CarouselOptions(
                            height: 200.sp,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            disableCenter: true,
                            pageSnapping: false
                        ),
                        items: [Resources.card1,Resources.card1,Resources.card1].map((data) {
                          return Builder(
                            builder: (BuildContext context) {
                              return  CreditCardWidget(
                                enableFloatingCard: true,
                                glassmorphismConfig: Glassmorphism.defaultConfig(),
                                cardNumber: "1234 4321 5437 9543",
                                expiryDate: "23/06",
                                cardHolderName: Provider.of<CartViewModel>(context, listen: false).items.first.product?.coffeShopData?.name ?? "",
                                cvvCode: "176",
                                bankName: 'Credit Card',
                                frontCardBorder:Border.all(color: AppColors.kMainColor),
                                backCardBorder: Border.all(color: AppColors.kMainColor),
                                showBackView: false,
                                obscureCardNumber: true,
                                obscureCardCvv: true,
                                isHolderNameVisible: true,
                                cardBgColor: AppColors.kMainColor,
                                isSwipeGestureEnabled: true,
                                onCreditCardWidgetChange:
                                    (CreditCardBrand creditCardBrand) {},
                                customCardTypeIcons: <CustomCardTypeIcon>[
                                  CustomCardTypeIcon(
                                    cardType: CardType.mastercard,
                                    cardImage: Image.asset(
                                      'assets/mastercard.png',
                                      height: 48,
                                      width: 48,
                                    ),
                                  ),
                                ],
                              );

                              // return Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   height: 150.sp,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(15),
                              //     image: DecorationImage(
                              //       image: AssetImage(data ?? ""), // Replace with your offer image paths
                              //       fit: BoxFit.fill,
                              //     ),
                              //   ),
                              // );
                            },
                          );
                        }).toList(),
                      )

                    ],
                  ):
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Order payment", style: AppStyles.kTextStyle20,),
                  AppSize.h10.ph,

                  ListTile(
                    title: Text(Provider.of<CartViewModel>(context, listen: false).items.first.product?.coffeShopData?.name ?? ""),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Provider.of<CartViewModel>(context, listen: false).items.first.product?.coffeShopData?.ownerData?.name ?? ""),
                        Text(Provider.of<CartViewModel>(context, listen: false).items.first.product?.coffeShopData?.location ?? ""),
                      ],
                    ),
                    leading: FadeInImage.assetNetwork(
                      placeholder:  Resources.logo, // Local image shown while loading
                      image: Provider.of<CartViewModel>(context, listen: false).items.first.product?.coffeShopData?.logo ?? "",
                      height: 80.0,
                      width: 80.0,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Image.asset(
                          Resources.logo, // Fallback image if network image fails
                          height: 80.0,
                          width: 80.0,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  ),

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
                ],
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
                            if(_selectedPaymentSlider) {
                              OrderItem order = OrderItem();
                              order.menuItemId = [];
                              order.menuItemName = [];
                              order.cartItem = Provider.of<CartViewModel>(context, listen: false).items.cast();
                              order.cartItem?.forEach((e){
                                order.menuItemId?.add(e.product?.id ?? "");
                                order.menuItemName?.add(e.product?.name ?? "");
                              });
                              Provider.of<CartViewModel>(context, listen: false).orderCheckOut(order, order.menuItemId??[], order.menuItemName ?? []);
                            }else{
                              setState(() {
                                _selectedPaymentSlider = true;
                              });
                            }

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
                      }
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        _selectedPaymentSlider ?
                        setState(() {
                          _selectedPaymentSlider = false;
                        }) :
                        UI.pop();
                      },
                      child: Icon(Icons.arrow_back_outlined))
                ],
              )
            ],
          ),
        ));
  }
}
