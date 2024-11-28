import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  String? id;
  double? teste;
  double? price;
  double? speed;
  double? accuracy;
  DateTime? ratingDate;
  String? menuItemId;
  String? customerId;

  Rating(
      {this.id,
        this.teste,
        this.price,
        this.speed,
        this.accuracy,
        this.ratingDate,
        this.menuItemId,
        this.customerId});

  Rating.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teste = json['teste'];
    price = json['price'];
    speed = json['speed'];
    accuracy = json['accuracy'];
    ratingDate = (json['rating_date'] as Timestamp).toDate();
    menuItemId = json['menu_item_id'];
    customerId = json['customer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['teste'] = this.teste;
    data['price'] = this.price;
    data['speed'] = this.speed;
    data['accuracy'] = this.accuracy;
    data['rating_date'] = this.ratingDate;
    data['menu_item_id'] = this.menuItemId;
    data['customer_id'] = this.customerId;
    return data;
  }
}
