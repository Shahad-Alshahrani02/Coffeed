import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';
import 'package:template/features/Customer/cart/cart_viewModel.dart';
import 'package:template/features/Customer/orders/models/order.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/extentions/string_extensions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';


class VisaCardPaymentPage extends StatefulWidget {

  const VisaCardPaymentPage({Key? key}) : super(key: key);
  @override
  _VisaCardPaymentPageState createState() => _VisaCardPaymentPageState();
}

class _VisaCardPaymentPageState extends State<VisaCardPaymentPage> {
  bool isLightTheme = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   isLightTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    // );
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: AppSize.h450,
        width: double.infinity,
        padding: EdgeInsets.all(AppSize.w26),
        decoration: BoxDecoration(
          color: AppColors.kWhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSize.r30),
            topRight: Radius.circular(AppSize.r30),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Add New Card", style: AppStyles.kTextStyleHeader20,),
                // CreditCardWidget(
                //   enableFloatingCard: useFloatingAnimation,
                //   glassmorphismConfig: _getGlassmorphismConfig(),
                //   cardNumber: cardNumber,
                //   expiryDate: expiryDate,
                //   cardHolderName: cardHolderName,
                //   cvvCode: cvvCode,
                //   bankName: 'Credit Card',
                //   frontCardBorder: useGlassMorphism
                //       ? null
                //       : Border.all(color: Colors.white),
                //   backCardBorder: useGlassMorphism
                //       ? null
                //       : Border.all(color: Colors.black54),
                //   showBackView: isCvvFocused,
                //   obscureCardNumber: true,
                //   obscureCardCvv: true,
                //   isHolderNameVisible: true,
                //   cardBgColor: isLightTheme
                //       ? AppColors.kWhiteColor
                //       : AppColors.kMainColor,
                //   isSwipeGestureEnabled: true,
                //   onCreditCardWidgetChange:
                //       (CreditCardBrand creditCardBrand) {},
                //   customCardTypeIcons: <CustomCardTypeIcon>[
                //     CustomCardTypeIcon(
                //       cardType: CardType.mastercard,
                //       cardImage: Image.asset(
                //         'assets/mastercard.png',
                //         height: 48,
                //         width: 48,
                //       ),
                //     ),
                //   ],
                // ),
                CreditCardForm(
                  formKey: formKey,
                  obscureCvv: true,
                  obscureNumber: true,
                  cardNumber: cardNumber,
                  cvvCode: cvvCode,
                  isHolderNameVisible: true,
                  isCardNumberVisible: true,
                  isExpiryDateVisible: true,
                  cardHolderName: cardHolderName,
                  expiryDate: expiryDate,
                  inputConfiguration: InputConfiguration(
                    cardNumberDecoration: InputDecoration(
                      labelText: 'Number',
                      hintText: 'XXXX XXXX XXXX XXXX',
                      labelStyle: AppStyles.kTextStyle14,
                      hintStyle: AppStyles.kTextStyle12.copyWith(color: AppColors.kGreyColor),
                      errorStyle: AppStyles.kTextStyle12.copyWith(color: AppColors.kGreyColor),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.kWhiteColor)
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.kWhiteColor),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.kWhiteColor),
                      ),
                    ),
                    expiryDateDecoration: InputDecoration(
                      labelText: 'Expired Date',
                      hintText: 'XX/XX',
                      labelStyle: AppStyles.kTextStyle14,
                      hintStyle: AppStyles.kTextStyle12.copyWith(color: AppColors.kGreyColor),
                      errorStyle: AppStyles.kTextStyle12.copyWith(color: AppColors.kGreyColor),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.kWhiteColor)
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.kWhiteColor),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.kWhiteColor),
                      ),
                    ),
                    cvvCodeDecoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: 'XXX',
                      labelStyle: AppStyles.kTextStyle14,
                      hintStyle: AppStyles.kTextStyle12.copyWith(color: AppColors.kGreyColor),
                      errorStyle: AppStyles.kTextStyle12.copyWith(color: AppColors.kGreyColor),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.kWhiteColor)
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.kWhiteColor),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.kWhiteColor),
                      ),
                    ),
                    cardHolderDecoration: InputDecoration(
                      labelText: 'Card Holder',
                      labelStyle: AppStyles.kTextStyle14,
                      hintStyle: AppStyles.kTextStyle12.copyWith(color: AppColors.kGreyColor),
                      errorStyle: AppStyles.kTextStyle12.copyWith(color: AppColors.kGreyColor),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.kWhiteColor)
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.kWhiteColor),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.kWhiteColor),
                      ),
                    ),
                    cardHolderTextStyle: AppStyles.kTextStyle14,
                    cardNumberTextStyle: AppStyles.kTextStyle14,
                    expiryDateTextStyle: AppStyles.kTextStyle14,
                    cvvCodeTextStyle: AppStyles.kTextStyle14,
                  ),
                  onCreditCardModelChange: onCreditCardModelChange,
                ),
                AppSize.h10.ph,
                BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
                  bloc:   Provider.of<CartViewModel>(context, listen: false).loading,
                  builder: (context, state) {
                    return state.data ?
                    const Loading():
                    CustomButton(
                        title: "Add Card",
                        btnColor: AppColors.kBlackColor,
                        onClick: () => UI.pop()
                    );
                  }
                ),
              ],
            ),
        ),
      ),
    );
  }

  Glassmorphism? _getGlassmorphismConfig() {
    if (!useGlassMorphism) {
      return null;
    }

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return isLightTheme
        ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient)
        : Glassmorphism.defaultConfig();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}