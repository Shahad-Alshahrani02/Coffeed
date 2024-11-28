import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/Customer/cart/models/CartItem.dart';
import 'package:template/features/Customer/orders/models/order.dart';
import 'package:template/features/Customer/orders/order_viewModel.dart';
import 'package:template/features/Customer/orders/widgets/invoice.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBar.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  OrderViewModel viewModel = OrderViewModel();

  @override
  void initState() {
    viewModel.getOrdersProductsForEveryUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoices", style: AppStyles.kTextStyleHeader20,),
        leading: InkWell(
          onTap: () => UI.pop(),
          child: Icon(Icons.arrow_back_ios_rounded),
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
        color: AppColors.kWhiteColor,
        elevation: 4,
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '#',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${order.id}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.cartItem?.length,
                itemBuilder: (context, index) {
                  final cartItem = order.cartItem?[index];
                  return _buildCartItem(cartItem ?? CartItemValue());
                },
              ),
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
        'R.S${(cartItem.product!.newPrice! * cartItem.quantity).toStringAsFixed(2)}',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  double _calculateTotal(List<CartItemValue> cartItems) {
    return cartItems.fold(0, (sum, item) => sum + item.product!.newPrice! * item.quantity);
  }
}