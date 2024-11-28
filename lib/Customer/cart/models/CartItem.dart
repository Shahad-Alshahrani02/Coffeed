import 'package:template/features/coffee/coffees/models/menu.dart';

class CartItemValue {
  Menu? product;
  int quantity = 1;


  CartItemValue({this.product, this.quantity = 1});

  CartItemValue.fromJson(Map<String, dynamic> json) {
    product =
    json['product'] != null ? new Menu.fromJson(json['product']) : null;
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['quantity'] = this.quantity;
    return data;
  }

  void increment() {
    quantity++;
  }

  void decrement() {
    if (quantity > 1) {
      quantity--;
    }
  }
}