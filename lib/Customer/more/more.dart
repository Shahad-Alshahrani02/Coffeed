import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/Customer/more/widgets/List_Payment_widget.dart';
import 'package:template/features/Customer/orders/order_page.dart';
import 'package:template/features/admin/home/widgets/Admin_dashboard_widget.dart';
import 'package:template/features/authentication/profile_page.dart';
import 'package:template/features/coffee/orders/Coffee_Invoice_page.dart';
import 'package:template/features/coffee/orders/coffee_order_page.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSearchColor,
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        centerTitle: true,
        title: Text("More", style: AppStyles.kTextStyleHeader20,),
      ),
      body: Container(
        padding: EdgeInsets.all(10.sp),
        child: PrefManager.currentUser?.type == 1 ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: AppColors.kWhiteColor,
              child: ListTile(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context){
                        return ProfilePage();
                      })
                  );
                },
                leading: Image.asset(Resources.user, height: 30.sp,),
                title: Text("Profile", style: AppStyles.kTextStyleHeader18,),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            AppSize.h16.ph,
            const Text("Basic info"),
            Card(
              color: AppColors.kWhiteColor,
              child: ListTile(
                onTap: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return AdminDashboardWidget();
                    })
                  );
                },
                leading: Image.asset(Resources.dash, height: 30.sp,),
                title: Text("Dashboard", style: AppStyles.kTextStyleHeader18,),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          ],
        ) :
        PrefManager.currentUser?.type == 2 ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: AppColors.kWhiteColor,
              child: ListTile(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context){
                        return ProfilePage();
                      })
                  );
                },
                leading: Image.asset(Resources.user, height: 30.sp,),
                title: Text("Profile", style: AppStyles.kTextStyleHeader18,),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            AppSize.h16.ph,
            const Text("Basic info"),
            Card(
              color: AppColors.kWhiteColor,
              child: ListTile(
                onTap: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return ListPaymentWidget();
                    })
                  );
                },
                leading: Image.asset(Resources.order, height: 30.sp,),
                title: Text("Payment", style: AppStyles.kTextStyleHeader18,),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            Card(
              color: AppColors.kWhiteColor,
              child: ListTile(
                onTap: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return OrderPage();
                    })
                  );
                },
                leading: Image.asset(Resources.order, height: 30.sp,),
                title: Text("Invoices", style: AppStyles.kTextStyleHeader18,),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          ],
        ):

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: AppColors.kWhiteColor,
              child: ListTile(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context){
                        return ProfilePage();
                      })
                  );
                },
                leading: Image.asset(Resources.user, height: 30.sp,),
                title: Text("My Profile", style: AppStyles.kTextStyleHeader18,),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),

            Card(
              color: AppColors.kWhiteColor,
              child: ListTile(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context){
                        return ListPaymentWidget();
                      })
                  );
                },
                leading: Image.asset(Resources.advertise, height: 30.sp,),
                title: Text("Requests", style: AppStyles.kTextStyleHeader18,),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),

            Card(
              color: AppColors.kWhiteColor,
              child: ListTile(
                onTap: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return ListPaymentWidget();
                    })
                  );
                },
                leading: Image.asset(Resources.order, height: 30.sp,),
                title: Text("Cards", style: AppStyles.kTextStyleHeader18,),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),

            Card(
              color: AppColors.kWhiteColor,
              child: ListTile(
                onTap: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return CoffeeInvoicePage();
                    })
                  );
                },
                leading: Image.asset(Resources.order, height: 30.sp,),
                title: Text("Invoices", style: AppStyles.kTextStyleHeader18,),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}