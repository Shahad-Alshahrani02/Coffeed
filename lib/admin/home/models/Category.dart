class Category {
  String? id;
  String? name;
  String? coffeeShopId;

  Category({this.id, this.name, this.coffeeShopId});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    coffeeShopId = json['coffee_shop_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['coffee_shop_id'] = this.coffeeShopId;
    return data;
  }
}