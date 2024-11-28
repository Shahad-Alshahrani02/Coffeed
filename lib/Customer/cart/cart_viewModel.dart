
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:template/features/Customer/cart/models/CartItem.dart';
import 'package:template/features/coffee/coffees/models/menu.dart';
import 'package:template/features/Customer/orders/models/order.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/network/firebase_helper.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';
import 'package:uuid/uuid.dart';

class CartViewModel extends ChangeNotifier {
  FirebaseHelper firebaseHelper = FirebaseHelper();
  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<List<Service>?> selectServices = GenericCubit(null);
  GenericCubit<DateTime> selectedDate = GenericCubit(DateTime.now());
  GenericCubit<String?> selectedTime = GenericCubit(null);
  GenericCubit<List<String>> timeRanges = GenericCubit([]);

  GenericCubit<String?> locationCubit = GenericCubit(null);
  GenericCubit<String?> newLocationCubit = GenericCubit(null);
  GenericCubit<LatLng?> newPostion = GenericCubit(null);
  GenericCubit<List<Marker>> markers = GenericCubit(<Marker>[]);
  GenericCubit<DateTime?> selectedDateTime = GenericCubit(null);

  TextEditingController comment = TextEditingController();

  LatLng? currentPostion;

  orderCheckOut(OrderItem order, List<String> menuItemId, List<String> menuItemName) async{
    String orderId = Uuid().v4(); // Generate a unique ID for the product
    order.userId = PrefManager.currentUser!.id;
    order.user = PrefManager.currentUser;
    order.id = orderId;
    order.status = "Accepted";
    order.comment = comment.text;
    print("order.toJson()");
    print(order.toJson());
    if(order.cartItem?.isEmpty ?? false){
      UI.showMessage("Cart should have one product to checkout");
      return;
    }
    try {
      loading.onLoadingState();
      loading.onUpdateData(true);

      QuerySnapshot? querySnapshot = await firebaseHelper.addDocumentWithSpacificDocID(CollectionNames.ordersTable, orderId, order.toJson());
      querySnapshot?.docs.forEach((e){
        print("e.data()");
        print(e.data());
      });
      UI.showMessage("Order added success");
      loading.onUpdateData(false);
      UI.push(AppRoutes.ratingPage, arguments: [menuItemId, menuItemName]);
      clearCart();
    }catch (e){
      print("add product exception  >>>   $e");
    }
  }

  List<CartItemValue> items = [];

  void addToCart(Menu product) {
    for (var item in items) {
      if (item.product?.coffeeShopId == product.coffeeShopId){
        if (item.product?.name == product.name) {
          item.increment();
          UI.showMessage("Increment the quantity of product success");
          notifyListeners();
          return;
        }
      }else{
        UI.showMessage("There is an existing coffee shop data in the cart");
        return;
      }
    }
    items.add(CartItemValue(product: product));
    UI.showMessage("Added to cart success");
    notifyListeners();
  }

  void removeFromCart(Menu product) {
    items.removeWhere((item) => item.product?.name == product.name);
    notifyListeners();
  }

  void clearCart() {
    items.clear();
    notifyListeners();
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => items.fold(0, (sum, item) => sum + item.product!.newPrice! * item.quantity);


  List<String> generateTimeSlots(String startTime, String endTime) {
    // Define time format
    final timeFormat = DateFormat('hh:mm a');
    timeRanges.onLoadingState();

    // Parse the start and end time into DateTime objects
    DateTime start = timeFormat.parse(startTime);
    DateTime end = timeFormat.parse(endTime);

    List<String> timeSlots = [];

    // Loop through each hour from start to end
    while (start.isBefore(end)) {
      // Get the next hour
      DateTime nextHour = start.add(Duration(hours: 1));

      // Format the current and next hour into the desired format
      String timeSlot = "${timeFormat.format(start)} - ${timeFormat.format(nextHour)}";

      // Add the time slot to the list
      timeSlots.add(timeSlot);

      // Move to the next time slot
      start = nextHour;
    }

    timeRanges.onUpdateData(timeSlots);
    return timeSlots;
  }


  updateLocation(LatLng position) async{
    List newPlace =  await placemarkFromCoordinates(position.latitude, position.longitude);;
    Placemark placeMark  = newPlace[0];
    String compeletAddressInfor = '${placeMark.subThoroughfare} ${placeMark.thoroughfare}, ${placeMark.subLocality} ${placeMark.locality}, ${placeMark.subAdministrativeArea} ${placeMark.administrativeArea}, ${placeMark.postalCode} ${placeMark.country},';
    String specificAddress = '${placeMark.locality}, ${placeMark.country}';
    log("new locatio name $specificAddress");
    newPostion.onUpdateData(position);
    newLocationCubit.onUpdateData(compeletAddressInfor);
    locationCubit.onUpdateData(compeletAddressInfor);
    var mrks = [Marker(
      markerId: const MarkerId('SomeId'),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(15.0),
      infoWindow: const InfoWindow(
        title: 'title',
        snippet: 'address',
      ),)];
    markers.onUpdateData(mrks);
  }

}
