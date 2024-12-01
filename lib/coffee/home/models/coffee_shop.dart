import 'package:template/shared/models/user_model.dart';

class CoffeeShope {
  String? id;
  String? name;
  String? oppeningTime;
  String? closingHours;
  String? contactDetails;
  String? logo;
  String? location;
  double? long;
  double? lat;
  double? distance;
  String? ownerId;
  UserModel? ownerData;

  CoffeeShope(
      {this.id,
        this.name,
        this.oppeningTime,
        this.closingHours,
        this.contactDetails,
        this.logo,
        this.ownerId,
        this.location,
        this.ownerData});

  CoffeeShope.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    oppeningTime = json['oppening_time'];
    closingHours = json['closingHours'] ?? "";
    location = json['location'];
    lat = json['lat'] ?? 26.3207;
    long = json['long'] ?? 50.0788;
    contactDetails = json['contact_details'];
    logo = json['logo'];
    ownerId = json['owner_id'];
    ownerData = json['owner_data'] != null
        ? new UserModel.fromJson(json['owner_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['oppening_time'] = this.oppeningTime;
    data['closingHours'] = this.closingHours;
    data['contact_details'] = this.contactDetails;
    data['location'] = this.location;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['logo'] = this.logo;
    data['owner_id'] = this.ownerId;
    if (this.ownerData != null) {
      data['owner_data'] = this.ownerData!.toJson();
    }
    return data;
  }
}