import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/Customer/rating/models/rating.dart';
import 'package:template/features/Customer/rating/rating_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';
import 'package:uuid/uuid.dart';

class RatingPage extends StatefulWidget {
  final List<String> menuItemName;
  final List<String> menuItemId;
  const RatingPage({Key? key, required this.menuItemId, required this.menuItemName}) : super(key: key);

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        leading: InkWell(
          onTap: () => UI.pushWithRemove(AppRoutes.customerStartPage),
          child: const Icon(Icons.arrow_back_ios_rounded),
        ),
        centerTitle: true,
        title: Text(
          "Rate your drink",
          style: AppStyles.kTextStyleHeader20,
        ),
      ),
      backgroundColor: AppColors.kWhiteColor,
      body: Container(
        padding: EdgeInsets.all(5.sp),
        child: Column(
          children: [
            // Image.asset(Resources.header),
            Expanded(
              child: ListView.builder(
                itemCount: widget.menuItemId.length,
                itemBuilder: (context, index) {
                  return CardRate(menuItemId: widget.menuItemId[index], menuItemName: widget.menuItemName[index],);
                }
              ),
            ),
            AppSize.h16.ph,
            CustomButton(title: "Skip",
                btnColor: AppColors.kBlackColor,
                onClick: (){
                  UI.pushWithRemove(AppRoutes.customerStartPage);
            })
          ],
        ),
      ),
    );
  }


}


class CardRate extends StatefulWidget {
  final String menuItemName;
  final String menuItemId;
  const CardRate({Key? key, required this.menuItemId, required this.menuItemName}) : super(key: key);

  @override
  State<CardRate> createState() => _CardRateState();
}

class _CardRateState extends State<CardRate> {
  RatingViewModel viewModel = RatingViewModel();

  bool isRated = false;
  double testeRating = 0.0;
  double priceRating = 0.0;
  double speedRating = 0.0;
  double accuracyRating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSize.h20.ph,
        Text(widget.menuItemName, style: AppStyles.kTextStyle24,),
        AppSize.h10.ph,
        Card(
          elevation: 10,
          color: AppColors.kWhiteColor,
          shadowColor: AppColors.kBlackCColor,
          child: Container(
            padding: EdgeInsets.all(15.sp),
            width: MediaQuery.of(context).size.width - 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRatingRow('Teste', (rating) {
                  setState(() {
                    testeRating = rating;
                  });
                }),
                _buildRatingRow('Price', (rating) {
                  setState(() {
                    priceRating = rating;
                  });
                }),
                _buildRatingRow('Speed', (rating) {
                  setState(() {
                    speedRating = rating;
                  });
                }),
                _buildRatingRow('Accuracy', (rating) {
                  setState(() {
                    accuracyRating = rating;
                  });
                }),
                const SizedBox(height: 20),
                isRated ?
                const SizedBox() :
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
                        bloc: viewModel.loading,
                        builder: (context, state) {
                          return state.data ?
                          const Loading(): CustomButton(
                              title: "Submit",
                              width: 120.sp,
                              height: 40.sp,
                              textSize: 15.sp,
                              radius: 40,
                              btnColor: AppColors.kBlackColor,
                              onClick: () {
                                String ratingId = Uuid().v4(); // Generate a unique ID for the product
                                // Convert the ratings to JSON and print or send to backend
                                Rating rating = Rating(
                                    id: ratingId,
                                    teste: testeRating,
                                    price: priceRating,
                                    speed: speedRating,
                                    accuracy: accuracyRating,
                                    ratingDate: DateTime.now(),
                                    menuItemId: widget.menuItemId,
                                    customerId: PrefManager.currentUser?.id
                                );
                                print(rating.toJson());  // This will print the ratings as JSON
                                viewModel.addRating(rating);
                                setState(() {
                                  isRated = true;
                                });
                              });
                        }
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingRow(String title, Function(double) onRatingUpdate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
        RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          unratedColor: AppColors.kInputColor,
          // allowHalfRating: true,
          itemCount: 5,
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.yellow,
          ),
          onRatingUpdate: onRatingUpdate,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
