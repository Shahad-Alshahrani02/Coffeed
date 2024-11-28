import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:template/features/Customer/orders/models/order.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/models/failure.dart';
import 'package:template/shared/network/firebase_helper.dart';
import 'package:template/shared/prefs/pref_manager.dart';

class OrderViewModel{
  FirebaseHelper firebaseHelper = FirebaseHelper();
  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<List<OrderItem>> orders = GenericCubit([]);

  List<String> statuses = ["Accepted", "Being Prepared", "Ready For Pick-up"];

  getOrdersProductsForEveryUserID() async{
    try {
      orders.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.ordersTable, "userId", PrefManager.currentUser!.id);
      List<OrderItem> ords = [];
      results.forEach((res){
        print( res.data());
        ords.add(OrderItem.fromJson(res.data() as Map<String, dynamic>));
      });
      orders.onUpdateData(ords);
    }catch (e){
      orders.onUpdateData([]);
      print("get orders exception  >>>   $e");
    }
  }

  getOrdersProductsByDateTime(DateTime dateTime) async{
    try {
      orders.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.ordersTable, "userId", PrefManager.currentUser!.id);
      List<OrderItem> ords = [];
      results.forEach((res){
        print( res.data());
        OrderItem or = OrderItem.fromJson(res.data() as Map<String, dynamic>);
        if(DateFormat("yyyy-MM-dd").format(or.createdTime ?? DateTime.now()) == DateFormat("yyyy-MM-dd").format(dateTime)){
          ords.add(or);
        }
      });
      orders.onUpdateData(ords);
    }catch (e){
      orders.onUpdateData([]);
      print("get orders exception  >>>   $e");
    }
  }

  getOrdersForCoffeeOwneID() async{
    try {
      orders.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.getAllDocuments(CollectionNames.ordersTable);
      List<OrderItem> ords = [];
      results.forEach((res){
        print( res.data());
        bool isdone = false;
        var ord = OrderItem.fromJson(res.data() as Map<String, dynamic>);
        ord.cartItem?.forEach((e){
          if(e.product?.ownerId == PrefManager.currentUser?.id){
            isdone = true;
          }
        });
        if(isdone){
          ords.add(ord);
        }
      });
      orders.onUpdateData(ords);
    }catch (e){
      orders.onUpdateData([]);
      print("get orders exception  >>>   $e");
    }
  }

  updateOrderStatus(OrderItem order, String status) async{
    try{
      loading.onUpdateData(true);
      order.status = status;
      print("user.get() >>>>  ${order.toJson()}");

      await firebaseHelper.updateDocument(CollectionNames.ordersTable, order.id ?? "", order.toJson());
      if(PrefManager.currentUser?.type == 2) {
        getOrdersProductsForEveryUserID();
      }
      if(PrefManager.currentUser?.type == 1) {
        getOrdersProductsForEveryUserID();
      }
      if(PrefManager.currentUser?.type == 3) {
        getOrdersForCoffeeOwneID();
      }
      loading.onUpdateData(false);
    } on Failure catch (e) {
      loading.onUpdateData(false);
      loading.onErrorState(e);
    }
  }
}