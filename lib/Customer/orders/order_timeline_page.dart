import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:template/features/Customer/orders/models/order.dart';
import 'package:template/features/Customer/orders/order_viewModel.dart';
import 'package:template/features/Customer/orders/models/order.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';

class OrderTimelinePage extends StatefulWidget {
  const OrderTimelinePage({Key? key}) : super(key: key);

  @override
  State<OrderTimelinePage> createState() => _OrderTimelinePageState();
}

class _OrderTimelinePageState extends State<OrderTimelinePage> {
  OrderViewModel viewModel = OrderViewModel();

  @override
  void initState() {
    viewModel.getOrdersProductsForEveryUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      body: Padding(
        padding: EdgeInsets.only(top: 100.sp, left: 10.sp, right: 10.sp),
        child: Column(
          children: [
            // Date Calendar Row
            _buildWeeklyCalendar(),

            BlocBuilder<GenericCubit<List<OrderItem>>,
                GenericCubitState<List<OrderItem>>>(
                bloc: viewModel.orders,
                builder: (context, state) {
                  return state is GenericLoadingState ? const Loading()
                      :  state.data.isEmpty? const EmptyData():
                  Expanded(
                    child: ListView.builder(
                        itemCount: state.data.length,
                        padding: EdgeInsets.only(bottom: 150.sp),
                        itemBuilder: (context, index) {
                          final order = state.data[index];
                          return _buildTimelineItem(
                            context,
                            order,
                          );
                        }),
                  );
              }
            ),
          ],
        ),
      ),
    );
  }

  bool isAll = true;
  List<bool> isToday = [false,false,false,false,false,false,false];

  // Weekly Calendar displaying the current week
  Widget _buildWeeklyCalendar() {
    final DateTime now = DateTime.now();
    final int currentWeekday = now.weekday;
    final DateFormat formatter = DateFormat('EEE');

    // Get the start of the week (Monday)
    final DateTime startOfWeek = now.subtract(Duration(days: currentWeekday - 1));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        height: 90,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isAll = true;
                  for(int i = 0; i< isToday.length; i++){
                    isToday[i] = false;
                  }
                });
                viewModel.getOrdersProductsForEveryUserID();
              },
              child: Container(
                width: 60,
                height: 100.sp,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: isAll ? Colors.pink.shade100 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text('All', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 7, // Show 7 days for the week
                itemBuilder: (context, index) {
                  final DateTime date = startOfWeek.add(Duration(days: index));
                  // isToday = isAll? false : now.day == date.day && now.month == date.month;
              
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isAll = false;
                        for(int i = 0; i< isToday.length; i++){
                          if(index == i){
                            isToday[i] = true;
                          }else{
                            isToday[i] = false;
                          }
                        }
                      });
                      viewModel.getOrdersProductsByDateTime(date);
                      // Handle date selection
                    },
                    child: Container(
                      width: 60,
                      height: 100.sp,
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: isToday[index] ? Colors.pink.shade100 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${date.day}', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(formatter.format(date)), // e.g., Mon, Tue
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build timeline items
  Widget _buildTimelineItem(BuildContext context, OrderItem order) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Timeline Indicator
        Column(
          children: [
            Container(
              width: 20.sp,
              height: 20.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.pink),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(3),
              child: order.status == viewModel.statuses[2]? Container(
                width: 15.sp,
                height: 15.sp,
                decoration: BoxDecoration(
                  color: order.status == viewModel.statuses[2]?
                  AppColors.kGreyColor:
                  Colors.white,
                  border: Border.all(color: Colors.pink),
                  shape: BoxShape.circle,
                ),
              ): null,
            ),
            AppSize.h4.ph,
            Container(
              width: 2.sp,
              height: 80.sp,
              color: Colors.pink.shade200,
            ),
            AppSize.h4.ph,
          ],
        ),
        AppSize.h16.pw,
        // Timeline Content
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Timeline Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order is"+" "+ (order.status ?? ""),
                        style: AppStyles.kTextStyleHeader20,
                        maxLines: 1,
                      ),
                      SizedBox(height: 8),
                      Text(
                        order.comment ?? "",
                        maxLines: 2,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // Timeline Time
                Text(
                  DateFormat('hh:mm a').format(order.createdTime ?? DateTime.now()),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
