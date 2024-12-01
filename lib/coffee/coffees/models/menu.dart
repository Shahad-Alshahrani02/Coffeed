import 'package:template/features/admin/home/models/Category.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/shared/models/user_model.dart';

class Menu {
  String? id;
  String? name;
  String? image;
  String? ownerId;
  UserModel? ownerData;
  String? description;
  double? price;
  double? newPrice;
  double? poromotion;
  String? size;
  String? coffeeShopId;
  CoffeeShope? coffeShopData;
  String? categoryId;
  Category? categoryData;

  Menu(
      {this.id,
        this.name,
        this.image,
        this.ownerId,
        this.ownerData,
        this.description,
        this.price,
        this.poromotion,
        this.coffeeShopId,
        this.coffeShopData,
        this.categoryId,
        this.categoryData});

  Menu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    price = json['price'].toDouble();
    if(json['poromotion'] != null && json['price'] != null){
      newPrice = json['price'] - json['poromotion'].toDouble();
    }else{
      newPrice = json['price'].toDouble();
    }
    poromotion = json['poromotion'] == null ? 0 : json['poromotion'].toDouble();
    size = json['size'] ?? "Medium";
    coffeeShopId = json['coffee_shop_id'];
    coffeShopData = json['coffe_shop_data'] != null
        ? new CoffeeShope.fromJson(json['coffe_shop_data'])
        : null;
    ownerData = json['ownerData'] != null
        ? new UserModel.fromJson(json['ownerData'])
        : null;
    ownerId = json['ownerId'];
    categoryId = json['category_id'];
    categoryData = json['category_data'] != null
        ? new Category.fromJson(json['category_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['price'] = this.price;
    data['poromotion'] = this.poromotion ?? 0;
    data['size'] = this.size ?? "Medium";
    data['coffee_shop_id'] = this.coffeeShopId;
    if (this.coffeShopData != null) {
      data['coffe_shop_data'] = this.coffeShopData!.toJson();
    }
    if (this.ownerData != null) {
      data['ownerData'] = this.ownerData!.toJson();
    }
    data['ownerId'] = this.ownerId;
    data['category_id'] = this.categoryId;
    if (this.categoryData != null) {
      data['category_data'] = this.categoryData!.toJson();
    }
    return data;
  }
}

