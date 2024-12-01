import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:template/features/Customer/cart/models/CartItem.dart';
import 'package:template/features/Customer/orders/models/order.dart';
import 'package:template/features/Customer/orders/order_viewModel.dart';
import 'package:template/features/Customer/orders/widgets/invoice.dart';
import 'package:template/features/coffee/advertisment/advertisment_viewModel.dart';
import 'package:template/features/coffee/advertisment/models/advertisment.dart';
import 'package:template/features/coffee/orders/widgets/CoffeeInvoiceDetailsPage.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class CoffeeInvoicePage extends StatefulWidget {
  const CoffeeInvoicePage({Key? key}) : super(key: key);

  @override
  State<CoffeeInvoicePage> createState() => _CoffeeInvoicePageState();
}

class _CoffeeInvoicePageState extends State<CoffeeInvoicePage> {
  AdvertismentViewModel viewModel = AdvertismentViewModel();

  @override
  void initState() {
    viewModel.getAllAdvertisementForEveryUserIDWithoutEndDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        title: Text("Invoices", style: AppStyles.kTextStyleHeader20,),
        centerTitle: true,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40),
              bottomLeft: Radius.circular(40),
            ),
            borderSide: BorderSide.none
        ),
      ),
      body: BlocBuilder<GenericCubit<List<Advertisment>>,
          GenericCubitState<List<Advertisment>>>(
          bloc: viewModel.advertisments,
          builder: (context, state) {
            return state is GenericLoadingState ? const Loading()
                :  state.data.isEmpty? const EmptyData(): ListView.builder(
              itemCount: state.data.length,
              padding: EdgeInsets.only(bottom: 150.sp),
              itemBuilder: (context, index) {
                final order = state.data[index];
                return _buildOrderCard(order);
              },
            );
          }
      ),
    );
  }

  Widget _buildOrderCard(Advertisment order) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoffeeInvoiceDetailsPage(orderItem: order,)));
      },
      child: Card(
        color: AppColors.kWhiteColor,
        elevation: 10,
        shadowColor: AppColors.kBlackColor,
        margin: EdgeInsets.all(10.sp),
        child: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ID: ',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${order.id}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(height: 5.sp),
              Text(
                order.title ?? "",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cloud_done_outlined),
                      AppSize.h5.pw,
                      Text(order.isApporved == null ? "Pending": order.isApporved! ? "Accepted": "Rejected", style: AppStyles.kTextStyle14,)
                    ],
                  ),
                  Text(
                    '${DateFormat("y MMM d").format(order.startDate ?? DateTime.now())}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                ]
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItemValue cartItem) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          cartItem.product?.image??"",
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(cartItem.product?.name ?? "", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), ),
      subtitle: Text(cartItem.product?.description ?? "", maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        '${(cartItem.product!.newPrice! * cartItem.quantity).toStringAsFixed(2)}R.S',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  double _calculateTotal(List<CartItemValue> cartItems) {
    return cartItems.fold(0, (sum, item) => sum + item.product!.newPrice! * item.quantity);
  }
}