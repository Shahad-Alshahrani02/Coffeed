import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/shared/models/user_model.dart';

class Advertisment {
  String? id;
  String? title;
  String? description;
  double? price;
  DateTime? startDate;
  DateTime? endDate;
  String? image;
  bool? isApporved;
  String? coffeeShopOwnerId;
  UserModel? coffeeShopOwnerData;
  String? coffeeShopId;
  CoffeeShope? coffeeShopData;

  Advertisment(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.startDate,
        this.isApporved,
        this.price,
        this.endDate,
        this.coffeeShopOwnerId,
        this.coffeeShopOwnerData,
        this.coffeeShopId,
        this.coffeeShopData});

  Advertisment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'] ?? 0.0;
    image = json['image'];
    isApporved = json['isApporved'];
    startDate = (json['startDate'] as Timestamp).toDate();
    endDate = (json['endDate'] as Timestamp).toDate();
    print(startDate);
    print(endDate);
    coffeeShopOwnerId = json['coffee_shop_owner_id'];
    coffeeShopOwnerData = json['coffee_shop_owner_data'] != null
        ? new UserModel.fromJson(json['coffee_shop_owner_data'])
        : null;
    coffeeShopId = json['coffee_shop_id'];
    coffeeShopData = json['coffee_shop_data'] != null
        ? new CoffeeShope.fromJson(json['coffee_shop_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['description'] = this.description;
    data['isApporved'] = this.isApporved;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['image'] = this.image;
    data['coffee_shop_owner_id'] = this.coffeeShopOwnerId;
    if (this.coffeeShopOwnerData != null) {
      data['coffee_shop_owner_data'] = this.coffeeShopOwnerData!.toJson();
    }
    data['coffee_shop_id'] = this.coffeeShopId;
    if (this.coffeeShopData != null) {
      data['coffee_shop_data'] = this.coffeeShopData!.toJson();
    }
    return data;
  }
}
