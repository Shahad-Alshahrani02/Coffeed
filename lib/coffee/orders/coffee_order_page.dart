import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/Customer/cart/models/CartItem.dart';
import 'package:template/features/Customer/orders/models/order.dart';
import 'package:template/features/Customer/orders/order_viewModel.dart';
import 'package:template/features/Customer/orders/widgets/invoice.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class CoffeeOrderPage extends StatefulWidget {
  const CoffeeOrderPage({Key? key}) : super(key: key);

  @override
  State<CoffeeOrderPage> createState() => _CoffeeOrderPageState();
}

class _CoffeeOrderPageState extends State<CoffeeOrderPage> {
  OrderViewModel viewModel = OrderViewModel();

  @override
  void initState() {
    viewModel.getOrdersForCoffeeOwneID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        title: Text("Orders", style: AppStyles.kTextStyleHeader20,),
        centerTitle: true,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40),
              bottomLeft: Radius.circular(40),
            ),
            borderSide: BorderSide.none
        ),
      ),
      body: BlocBuilder<GenericCubit<List<OrderItem>>,
          GenericCubitState<List<OrderItem>>>(
          bloc: viewModel.orders,
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

  Widget _buildOrderCard(OrderItem order) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => InvoicePage(orderItem: order,)));
      },
      child: Card(
        color: AppColors.kSearchColor,
        elevation: 10,
        shadowColor: AppColors.kBlackColor,
        margin: EdgeInsets.all(10.sp),
        child: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(height: 10.sp),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.cartItem?.length,
                itemBuilder: (context, index) {
                  final cartItem = order.cartItem?[index];
                  return _buildCartItem(cartItem ?? CartItemValue());
                },
              ),
              SizedBox(height: 10.sp),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cloud_done_outlined),
                      AppSize.h5.pw,
                      Text(order.status ?? "", style: AppStyles.kTextStyle14,)
                    ],
                  ),
                  if (order.status == viewModel.statuses[0])
                    CustomButton(
                        title: viewModel.statuses[1],
                        height: 35.sp,
                        width: 100.sp,
                        radius: 40,
                        textSize: 13.sp,
                        btnColor: AppColors.kBlackCColor,
                        onClick: (){
                          if(order.status == viewModel.statuses[0]){
                            viewModel.updateOrderStatus(order, viewModel.statuses[1]);
                          }else if(order.status == viewModel.statuses[1]){
                            viewModel.updateOrderStatus(order, viewModel.statuses[2]);
                          }
                        })

                  else if (order.status == viewModel.statuses[1])
                    CustomButton(
                        title: viewModel.statuses[2],
                        height: 35.sp,
                        width: 100.sp,
                        radius: 40,
                        textSize: 13.sp,
                        btnColor: AppColors.kBlackCColor,
                        onClick: (){
                          if(order.status == viewModel.statuses[0]){
                            viewModel.updateOrderStatus(order, viewModel.statuses[1]);
                          }else if(order.status == viewModel.statuses[1]){
                            viewModel.updateOrderStatus(order, viewModel.statuses[2]);
                          }
                        })
                ],
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
