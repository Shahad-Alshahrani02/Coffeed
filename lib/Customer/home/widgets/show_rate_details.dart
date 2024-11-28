  import 'package:fl_chart/fl_chart.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:provider/provider.dart';
  import 'package:template/features/Customer/cart/cart_viewModel.dart';
import 'package:template/features/Customer/cart/widgets/CartIconWidget.dart';
  import 'package:template/features/Customer/home/widgets/show_menu_details.dart';
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
import 'package:template/shared/prefs/pref_manager.dart';
  import 'package:template/shared/resources.dart';
  import 'package:template/shared/ui/componants/custom_button.dart';
  import 'package:template/shared/ui/componants/custom_field.dart';
  import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';
  import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';
  import 'package:syncfusion_flutter_charts/charts.dart';
  import 'package:syncfusion_flutter_charts/sparkcharts.dart';


  class ShowRateDetails extends StatefulWidget {
    final Menu menu;
    const ShowRateDetails({Key? key, required this.menu}) : super(key: key);

    @override
    State<ShowRateDetails> createState() => _ShowRateDetailsState();
  }

  class _ShowRateDetailsState extends State<ShowRateDetails> {
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
          title: Text( widget.menu.name ?? "", style: AppStyles.kTextStyle24.copyWith(
            fontWeight: FontWeight.bold
          ),),
          // actions: const [
          //   Padding(
          //     padding: EdgeInsets.symmetric(vertical: 30.0),
          //     child: CartIconWidget(),
          //   )
          // ],
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
                Container(
                  color: AppColors.kWhiteColor,
                  padding: EdgeInsets.all(10.sp),
                  child: Column(
                    children: [
                      AppSize.h10.ph,
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(widget.menu.newPrice.toString() ?? "", style: AppStyles.kTextStyle20,),
                                AppSize.h5.pw,
                                Text("R.S", style: AppStyles.kTextStyle20,),
                              ],
                            ),
                          ),
                          PrefManager.currentUser?.type == 2?
                          IconButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ShowMenuDetails(menu: widget.menu,)));
                          },
                              icon: Image.asset(Resources.cart, height: 25.sp,)
                          ): const SizedBox(),
                        ],
                      ),
                      AppSize.h10.ph,
                      Text(widget.menu.description ?? "", style: AppStyles.kTextStyle20),
                      AppSize.h5.ph,
                      Row(
                        children: [
                          Text("Category: ", style: AppStyles.kTextStyle20,),
                          AppSize.h5.pw,
                          Text(widget.menu.categoryData?.name ?? "", style: AppStyles.kTextStyle20),
                        ],
                      ),
                      AppSize.h5.ph,
                      widget.menu == null ?
                      SizedBox():
                      ShowRatingsPage(widget.menu),
                      AppSize.h20.ph,
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

  class ShowRatingsPage extends StatefulWidget {
    final Menu currentMenu;
    ShowRatingsPage(this.currentMenu);
    @override
    _RatingsPageState createState() => _RatingsPageState();
  }

  class _RatingsPageState extends State<ShowRatingsPage> {
    late Menu currentMenu;
    RatingViewModel viewModel = RatingViewModel();
    CoffeeViewModel coffeeViewModel = CoffeeViewModel();

    final List<String> categories = ["Taste", "Price", "Speed", "Accuracy"];

    // Selected category index
    int selectedCategoryIndex = 0;

    // Simulated ratings for each category
    final List<double> tasteRatings = [];
    final List<String> tasteMenuItemNames = [];
    final List<double> priceRatings = [];
    final List<String> priceMenuItemNames = [];
    final List<double> speedRatings = [];
    final List<String> speedMenuItemNames = [];
    final List<double> accuracyRatings = [];
    final List<String> accuracyMenuItemNames = [];

    getData() async{
      currentMenu = widget.currentMenu;
      List<Menu> menus = await coffeeViewModel.getAllMenus();
      print(menus);
      menus.forEach((e) async{
        List<Rating> ratings = await viewModel.getAllRatingsByMenuItemID(e.id ?? "");

        double allTeste = 0;
        double allPrice = 0;
        double allSpeed = 0;
        double allAccuracy = 0;

        print(ratings);
        ratings.forEach((el){
          allTeste += el.teste!;
          allPrice += el.price!;
          allSpeed += el.speed!;
          allAccuracy += el.accuracy!;
        });

        print("allTeste");
        print(allTeste);

        print("allPrice");
        print(allPrice);

        print("allSpeed");
        print(allSpeed);

        print("allAccuracy");
        print(allAccuracy);

        setState(() {
          if(allTeste != 0) {
            tasteRatings.add(allTeste / ratings.length);
            tasteMenuItemNames.add(e.name ?? "");
          }
          if(allPrice != 0) {
            priceRatings.add(allPrice/ ratings.length);
            priceMenuItemNames.add(e.name ?? "");
          }
          if(allSpeed != 0) {
            speedRatings.add(allSpeed/ ratings.length);
            speedMenuItemNames.add(e.name ?? "");
          }
          if(allAccuracy != 0) {
            accuracyRatings.add(allAccuracy/ ratings.length);
            accuracyMenuItemNames.add(e.name ?? "");
          }
        });
      });

    }

    @override
    void initState() {
      getData();
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      print("speedRatings");
      print(speedRatings);

      print("priceRatings");
      print(priceRatings);

      print("speedRatings");
      print(speedRatings);

      print("accuracyRatings");
      print(accuracyRatings);
      return Column(
        children: [
          // Switchable buttons for categories
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: categories.asMap().entries.map((entry) {
          //     int index = entry.key;
          //     String category = entry.value;
          //     return InkWell(
          //       onTap: (){
          //         setState(() {
          //           selectedCategoryIndex = index; // Update selected category
          //         });
          //       },
          //       child: Card(
          //         color: selectedCategoryIndex == index ?
          //         AppColors.kRateColor :
          //         AppColors.kWhiteColor,
          //         elevation: 5,
          //         shape: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(20),
          //           borderSide: BorderSide.none
          //         ),
          //         child: Padding(
          //           padding: EdgeInsets.symmetric(horizontal: 20.sp,vertical: 10.sp),
          //           child: Text(category, style: AppStyles.kTextStyle14.copyWith(
          //             color: selectedCategoryIndex != index ?
          //             AppColors.kRateColor :
          //             AppColors.kWhiteColor,
          //           ),),
          //         ),
          //       ),
          //     );
          //   }).toList(),
          // ),
          // SizedBox(height: 20),
          // Display the chart based on the selected category
          buildRatingChart(),
        ],
      );
    }

    // Function to return ratings based on selected category
    List<double> getCurrentRatings() {
      switch (selectedCategoryIndex) {
        case 0:
          return tasteRatings;
        case 1:
          return priceRatings;
        case 2:
          return speedRatings;
        case 3:
          return accuracyRatings;
        default:
          return [];
      }
    }

    // Function to return ratings based on selected category
    List<String> getCurrentNames() {
      switch (selectedCategoryIndex) {
        case 0:
          return tasteMenuItemNames;
        case 1:
          return priceMenuItemNames;
        case 2:
          return speedMenuItemNames;
        case 3:
          return accuracyMenuItemNames;
        default:
          return [];
      }
    }

    List<_StatusData> data = [];

    // Function to build the rating chart for each element
    Widget buildRatingChart() {
      List<double> ratings = getCurrentRatings();
      List<String> names = getCurrentNames();
      String selectedCategory = categories[selectedCategoryIndex];

      data = [];
     if(ratings.isNotEmpty) {
      for (int i = 0; i < categories.length; i++) {
        data.add(_StatusData(categories[i] ?? "", ratings[i]));
      }
    }

    print("names ???");
      print(names);
      return SizedBox(
        height: 300.sp,
        child: RotatedBox(
          quarterTurns: 0,
          child: SfCartesianChart(
            enableAxisAnimation: true,
            primaryXAxis: CategoryAxis(
              isVisible: true,
              labelStyle: AppStyles.kTextStyle20,
            ),
            primaryYAxis: NumericAxis(
              labelStyle: AppStyles.kTextStyle13,
              labelRotation: 0, // You can rotate Y-Axis labels if needed
            ),
            title: ChartTitle(
              text: "Ratings",
              textStyle: AppStyles.kTextStyle16.copyWith(
                  fontWeight: FontWeight.bold
              ),
            ),
            legend: const Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              textStyle: AppStyles.kTextStyle16,
            ),
            series: <CartesianSeries<_StatusData, String>>[
              BarSeries<_StatusData, String>(
                legendIconType: LegendIconType.circle,
                animationDuration: 3000,
                dataSource: data,
                xValueMapper: (_StatusData status, _) => status.status,
                yValueMapper: (_StatusData status, _) => status.count,
                name: 'Status',
                color: AppColors.kMainColor,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true, // Show data labels on bars
                  textStyle: AppStyles.kTextStyle16.copyWith(
                    fontSize: 10.sp, // Reduce font size of labels
                    color: Colors.white,
                  ),
                  labelAlignment: ChartDataLabelAlignment.auto, // Auto-align labels
                  builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                    return Text(
                      data.count.toString(), // Display the count value as the label
                      style: AppStyles.kTextStyle16.copyWith(
                        fontSize: 10.sp, // Adjust label size here
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                width: 0.3, // Adjust this value to make bars thinner (0.0 to 1.0)
                pointColorMapper: (_StatusData status, _) {
                  if(currentMenu.name == status.status){
                    return AppColors.kRateColor;
                  }else{
                    return AppColors.kTextFieldColor;
                  }
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  class _StatusData {
    _StatusData(this.status, this.count);

    final String status;
    final double count;
  }

  /*class ShowRatingsPage extends StatefulWidget {
    final Menu currentMenu;
    ShowRatingsPage(this.currentMenu);
    @override
    _RatingsPageState createState() => _RatingsPageState();
  }

  class _RatingsPageState extends State<ShowRatingsPage> {
    late Menu currentMenu;
    RatingViewModel viewModel = RatingViewModel();
    CoffeeViewModel coffeeViewModel = CoffeeViewModel();

    final List<String> categories = ["Taste", "Price", "Speed", "Accuracy"];

    // Selected category index
    int selectedCategoryIndex = 0;

    // Simulated ratings for each category
    final List<double> tasteRatings = [];
    final List<String> tasteMenuItemNames = [];
    final List<double> priceRatings = [];
    final List<String> priceMenuItemNames = [];
    final List<double> speedRatings = [];
    final List<String> speedMenuItemNames = [];
    final List<double> accuracyRatings = [];
    final List<String> accuracyMenuItemNames = [];

    getData() async{
      currentMenu = widget.currentMenu;
      List<Menu> menus = await coffeeViewModel.getAllMenus();
      print(menus);
      menus.forEach((e) async{
        List<Rating> ratings = await viewModel.getAllRatingsByMenuItemID(e.id ?? "");

        double allTeste = 0;
        double allPrice = 0;
        double allSpeed = 0;
        double allAccuracy = 0;

        print(ratings);
        ratings.forEach((el){
          allTeste += el.teste!;
          allPrice += el.price!;
          allSpeed += el.speed!;
          allAccuracy += el.accuracy!;
        });

        print("allTeste");
        print(allTeste);

        print("allPrice");
        print(allPrice);

        print("allSpeed");
        print(allSpeed);

        print("allAccuracy");
        print(allAccuracy);

        setState(() {
          if(allTeste != 0) {
            tasteRatings.add(allTeste / ratings.length);
            tasteMenuItemNames.add(e.name ?? "");
          }
          if(allPrice != 0) {
            priceRatings.add(allPrice/ ratings.length);
            priceMenuItemNames.add(e.name ?? "");
          }
          if(allSpeed != 0) {
            speedRatings.add(allSpeed/ ratings.length);
            speedMenuItemNames.add(e.name ?? "");
          }
          if(allAccuracy != 0) {
            accuracyRatings.add(allAccuracy/ ratings.length);
            accuracyMenuItemNames.add(e.name ?? "");
          }
        });
      });

    }

    @override
    void initState() {
      getData();
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      print("speedRatings");
      print(speedRatings);

      print("priceRatings");
      print(priceRatings);

      print("speedRatings");
      print(speedRatings);

      print("accuracyRatings");
      print(accuracyRatings);
      return Column(
        children: [
          // Switchable buttons for categories
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: categories.asMap().entries.map((entry) {
              int index = entry.key;
              String category = entry.value;
              return InkWell(
                onTap: (){
                  setState(() {
                    selectedCategoryIndex = index; // Update selected category
                  });
                },
                child: Card(
                  color: selectedCategoryIndex == index ?
                  AppColors.kRateColor :
                  AppColors.kWhiteColor,
                  elevation: 5,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp,vertical: 10.sp),
                    child: Text(category, style: AppStyles.kTextStyle14.copyWith(
                      color: selectedCategoryIndex != index ?
                      AppColors.kRateColor :
                      AppColors.kWhiteColor,
                    ),),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          // Display the chart based on the selected category
          buildRatingChart(),
        ],
      );
    }

    // Function to return ratings based on selected category
    List<double> getCurrentRatings() {
      switch (selectedCategoryIndex) {
        case 0:
          return tasteRatings;
        case 1:
          return priceRatings;
        case 2:
          return speedRatings;
        case 3:
          return accuracyRatings;
        default:
          return [];
      }
    }

    // Function to return ratings based on selected category
    List<String> getCurrentNames() {
      switch (selectedCategoryIndex) {
        case 0:
          return tasteMenuItemNames;
        case 1:
          return priceMenuItemNames;
        case 2:
          return speedMenuItemNames;
        case 3:
          return accuracyMenuItemNames;
        default:
          return [];
      }
    }

    List<_StatusData> data = [];

    // Function to build the rating chart for each element
    Widget buildRatingChart() {
      List<double> ratings = getCurrentRatings();
      List<String> names = getCurrentNames();
      String selectedCategory = categories[selectedCategoryIndex];

      data = [];
      for(int i = 0; i< ratings.length; i++){
        data.add(
            _StatusData(names[i] ?? "", ratings[i])
        );
      }

      print("names ???");
      print(names);
      return SizedBox(
        height: 300.sp,
        child: RotatedBox(
          quarterTurns: 0,
          child: SfCartesianChart(
            enableAxisAnimation: true,
            primaryXAxis: CategoryAxis(
              isVisible: true,
              labelStyle: AppStyles.kTextStyle20,
            ),
            primaryYAxis: NumericAxis(
              labelStyle: AppStyles.kTextStyle13,
              labelRotation: 0, // You can rotate Y-Axis labels if needed
            ),
            title: ChartTitle(
              text: "$selectedCategory Ratings",
              textStyle: AppStyles.kTextStyle16.copyWith(
                  fontWeight: FontWeight.bold
              ),
            ),
            legend: const Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              textStyle: AppStyles.kTextStyle16,
            ),
            series: <CartesianSeries<_StatusData, String>>[
              BarSeries<_StatusData, String>(
                legendIconType: LegendIconType.circle,
                animationDuration: 3000,
                dataSource: data,
                xValueMapper: (_StatusData status, _) => status.status,
                yValueMapper: (_StatusData status, _) => status.count,
                name: 'Status',
                color: AppColors.kMainColor,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true, // Show data labels on bars
                  textStyle: AppStyles.kTextStyle16.copyWith(
                    fontSize: 10.sp, // Reduce font size of labels
                    color: Colors.white,
                  ),
                  labelAlignment: ChartDataLabelAlignment.auto, // Auto-align labels
                  builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                    return Text(
                      data.count.toString(), // Display the count value as the label
                      style: AppStyles.kTextStyle16.copyWith(
                        fontSize: 10.sp, // Adjust label size here
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                width: 0.3, // Adjust this value to make bars thinner (0.0 to 1.0)
                pointColorMapper: (_StatusData status, _) {
                  if(currentMenu.name == status.status){
                    return AppColors.kRateColor;
                  }else{
                    return AppColors.kTextFieldColor;
                  }
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  class _StatusData {
    _StatusData(this.status, this.count);

    final String status;
    final double count;
  }*/