import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:template/features/Customer/cart/cart_viewModel.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/util/ui.dart';

class ListPaymentWidget extends StatelessWidget {
  ListPaymentWidget({Key? key}) : super(key: key);

  List<Color> colors = [
    AppColors.kMainColor,
    AppColors.kSecondryColor,
    AppColors.kFogColor,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment", style: AppStyles.kTextStyleHeader20,),
        leading: InkWell(
          onTap: () => UI.pop(),
          child: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("YOUR CARDS"),
            Expanded(
              child: ListView.builder(
                itemCount: colors.length,
                itemBuilder: (BuildContext context, int index) {
                  final LinearGradient gradient = LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[colors[index], colors[index]],
                    stops: const <double>[0.3, 0],
                  );
        
                  return CreditCardWidget(
                    enableFloatingCard: true,
                    glassmorphismConfig: Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient),
                    cardNumber: "${index + 1}234 4321 5437 9543",
                    expiryDate: "23/06",
                    cardHolderName: PrefManager.currentUser?.name ?? "",
                    cvvCode: "176",
                    bankName: 'Credit Card',
                    frontCardBorder:Border.all(color: AppColors.kMainColor),
                    backCardBorder: Border.all(color: AppColors.kMainColor),
                    showBackView: false,
                    obscureCardNumber: true,
                    obscureCardCvv: true,
                    isHolderNameVisible: true,
                    cardBgColor: colors[index],
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
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
