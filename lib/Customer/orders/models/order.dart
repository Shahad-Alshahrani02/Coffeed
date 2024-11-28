import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template/features/Customer/cart/models/CartItem.dart';
import 'package:template/shared/models/user_model.dart';

class OrderItem {
  String? id;
  String? userId;
  UserModel? user;
  String? comment;
  DateTime? createdTime;
  List<String>? menuItemId;
  List<String>? menuItemName;
  String? status;
  List<CartItemValue>? cartItem;

  OrderItem({this.id, this.userId, this.cartItem});

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    comment = json['comment'];
    createdTime = json['createdTime'] != null?  (json['createdTime'] as Timestamp).toDate() : DateTime.now();
    user = UserModel.fromJson(json['user']);
    status = json['status'];
    if (json['cartItem'] != null) {
      cartItem = <CartItemValue>[];
      json['cartItem'].forEach((v) {
        cartItem!.add(new CartItemValue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['comment'] = this.comment;
    data['createdTime'] = DateTime.now();
    data['menuItemId'] = this.menuItemId;
    data['status'] = this.status;
    data['user'] = this.user?.toJson();
    if (this.cartItem != null) {
      data['cartItem'] = this.cartItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}