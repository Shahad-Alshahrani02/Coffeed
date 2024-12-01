
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/features/coffee/home/widgets/ListCoffeeShops.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/network/firebase_helper.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/helper.dart';
import 'package:template/shared/util/ui.dart';
import 'package:uuid/uuid.dart';

class HomeViewModel{
  FirebaseHelper firebaseHelper = FirebaseHelper();
  GenericCubit<File?> imageFile = GenericCubit(null);
  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<List<CoffeeShope>> coffeeShopes = GenericCubit([]);
  GenericCubit<List<CoffeeShope>> allCoffeeShopes = GenericCubit([]);
  GenericCubit<List<CoffeeShope>> allCoffeeShopesBaseOnCategory = GenericCubit([]);
  GenericCubit<List<CoffeeShope>> searchedCoffeeShopes = GenericCubit([]);
  GenericCubit<LatLng?> newPostion = GenericCubit(null);

  final formKey = GlobalKey<FormState>();

  TextEditingController search = TextEditingController(text: "");
  TextEditingController name = TextEditingController(text: "");
  TextEditingController phone = TextEditingController(text: "");
  TextEditingController location = TextEditingController(text: "");
  TextEditingController openingHours = TextEditingController(text: "");
  TextEditingController closingHours = TextEditingController(text: "");

  String imageUpdateURL = "";

  // Function to pick an image from the device
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.onUpdateData(File(pickedFile.path));
    }
  }

  serchOnCoffees(String searchText) async{
    try {
      searchedCoffeeShopes.onLoadingState();
      print(searchText);
      List<CoffeeShope> sals = [];
      allCoffeeShopes.state.data.forEach((res){
        if(res.name?.toLowerCase().contains(searchText.toLowerCase()) ?? false){
          sals.add(res);
        }
      });
      searchedCoffeeShopes.onUpdateData(sals);
    }catch (e){
      searchedCoffeeShopes.onUpdateData([]);
      print("get searched CoffeeShopes exception  >>>   $e");
    }
  }

  addCoffeeShope() async{
    if (!formKey.currentState!.validate()){
      return;
    }

    if(imageFile.state.data == null){
      UI.showMessage("Upload Service image");
      return;
    }

    CoffeeShope serv = CoffeeShope();
    String coffeeId = Uuid().v4(); // Generate a unique ID for the service

    try {
      loading.onLoadingState();
      loading.onUpdateData(true);
      String urlCoffeeImage = await firebaseHelper.uploadImage(
          imageFile.state.data ?? File(""));

      serv.id = coffeeId;
      serv.name = name.text;
      serv.contactDetails = phone.text;
      serv.oppeningTime = openingHours.text;
      serv.closingHours = closingHours.text;
      serv.location = location.text;
      serv.lat = newPostion.state.data?.latitude;
      serv.long = newPostion.state.data?.longitude;
      serv.ownerId = PrefManager.currentUser?.id;
      serv.ownerData = PrefManager.currentUser;
      serv.logo = urlCoffeeImage;

      QuerySnapshot? querySnapshot = await firebaseHelper.addDocumentWithSpacificDocID(CollectionNames.coffeeShopsTable, coffeeId, serv.toJson());
      querySnapshot?.docs.forEach((e){
        print("e.data()");
        print(e.data());
      });
      UI.showMessage("coffee shop added success");
      getAllCoffeeShopesForEveryUserID();
      loading.onUpdateData(false);
      UI.pop();
    }catch (e){
      loading.onUpdateData(false);
      print("add coffee shop exception  >>>   $e");
    }
  }

  fillData(CoffeeShope a) async{
    name.text = a.name!;
    phone.text = a.contactDetails!;
    openingHours.text = a.oppeningTime!;
    closingHours.text = a.closingHours!;
    location.text = a.location!;
    newPostion.onUpdateData(LatLng(a.lat ?? 0.0, a.long?? 0.0));
    imageUpdateURL = a.logo!;
    imageFile.onUpdateData(await Helper.getImageFileByUrl(a.logo!));
  }

  updateCoffeeShope(String coffeeId) async{
    if (!formKey.currentState!.validate()){
      return;
    }

    if(imageFile.state.data == null){
      UI.showMessage("Upload Service image");
      return;
    }

    CoffeeShope serv = CoffeeShope();
    try {
      loading.onLoadingState();
      loading.onUpdateData(true);
      String urlCoffeeImage = await firebaseHelper.updateImage(
          imageFile.state.data ?? File(""),
          imageUpdateURL
      );

      serv.id = coffeeId;
      serv.name = name.text;
      serv.contactDetails = phone.text;
      serv.oppeningTime = openingHours.text;
      serv.closingHours = closingHours.text;
      serv.location = location.text;
      serv.lat = newPostion.state.data?.latitude;
      serv.long = newPostion.state.data?.longitude;
      serv.ownerId = PrefManager.currentUser?.id;
      serv.ownerData = PrefManager.currentUser;
      serv.logo = urlCoffeeImage;

      await firebaseHelper.updateDocument(CollectionNames.coffeeShopsTable, coffeeId, serv.toJson());
      UI.showMessage("coffee shop updated success");
      getAllCoffeeShopesForEveryUserID();
      loading.onUpdateData(false);
      UI.pop();
    }catch (e){
      loading.onUpdateData(false);
      print("update coffee shop exception  >>>   $e");
    }
  }

  deleteCoffeeShop(String coffeeId) async{
    try {
      loading.onLoadingState();
      loading.onUpdateData(true);
      await firebaseHelper.deleteDocument(CollectionNames.coffeeShopsTable, coffeeId);
      UI.showMessage("Coffee shope deleted success");
      loading.onUpdateData(false);
    }catch (e){
      loading.onUpdateData(false);
      print("delete coffee shop exception  >>>   $e");
    }
  }

  getAllCoffeeShopesForEveryUserID() async{
    try {
      coffeeShopes.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.coffeeShopsTable, "owner_id", PrefManager.currentUser!.id);
      List<CoffeeShope> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(CoffeeShope.fromJson(res.data() as Map<String, dynamic>));
      });
      coffeeShopes.onUpdateData(servs);
    }catch (e){
      coffeeShopes.onUpdateData([]);
      print("coffeeshopes exception  >>>   $e");
    }
  }

  getAllCoffeeShops() async{
    try {
      allCoffeeShopes.onLoadingState();
      // get current location
      LocationPermission permission;
      permission = await Geolocator.requestPermission();
      print(permission);
      Position position = await Geolocator.getCurrentPosition();

      List<QueryDocumentSnapshot> results = await firebaseHelper.getAllDocuments(CollectionNames.coffeeShopsTable);
      List<CoffeeShope> servs = [];
      print("getAllCoffeeShops");
      results.forEach((res){
        print(res.data());
        servs.add(CoffeeShope.fromJson(res.data() as Map<String, dynamic>));
      });
      servs.forEach((e){
        e.distance = caculateDistance(e.lat ?? 0.0, e.long ?? 0.0, position);
      });
      servs.sort((a,b) => b.distance?.compareTo(a.distance ?? 0.0 ) ?? 0);
      allCoffeeShopes.onUpdateData(servs);
    }catch (e){
      allCoffeeShopes.onUpdateData([]);
      print("allCoffeeShopes exception  >>>   $e");
    }
  }

  double caculateDistance(double lat, double lng, Position position){
    print(
        'caculateDistance Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    double distanceInMeters = Geolocator.distanceBetween(lat, lng, position.latitude, position.longitude);
    print(distanceInMeters);
    double distanceInKiloMeters = distanceInMeters / 1000;
    double roundDistanceInKM =
    double.parse((distanceInKiloMeters).toStringAsFixed(2));
    return roundDistanceInKM;
  }

  getAllCoffeeShopsSortingBaseLocation() async{
    try {
      allCoffeeShopesBaseOnCategory.onLoadingState();
      allCoffeeShopes.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.getAllDocuments(CollectionNames.coffeeShopsTable);
      List<CoffeeShope> servs = [];
      print("getAllCoffeeShops");
      results.forEach((res){
        print(res.data());
        servs.add(CoffeeShope.fromJson(res.data() as Map<String, dynamic>));
      });
      servs.sort((a,b) => a.long?.compareTo(b.long ?? 0) ?? 0);
      allCoffeeShopes.onUpdateData(servs);
      allCoffeeShopesBaseOnCategory.onUpdateData(servs);
    }catch (e){
      allCoffeeShopes.onUpdateData([]);
      allCoffeeShopesBaseOnCategory.onUpdateData([]);
      print("allCoffeeShopes exception  >>>   $e");
    }
  }

  Future<List<CoffeeShope>> getAllCoffeeShopsWithReturnData() async{
    try {
      allCoffeeShopes.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.getAllDocuments(CollectionNames.coffeeShopsTable);
      List<CoffeeShope> servs = [];
      print("getAllCoffeeShops");
      results.forEach((res){
        print(res.data());
        servs.add(CoffeeShope.fromJson(res.data() as Map<String, dynamic>));
      });
      allCoffeeShopes.onUpdateData(servs);
      return servs;
    }catch (e){
      allCoffeeShopes.onUpdateData([]);
      print("allCoffeeShopes exception  >>>   $e");
      return [];
    }
  }


  getCurrentLoc() async{
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    updateLocation(LatLng(position.latitude, position.longitude));
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever){
        UI.showMessage(
            "Please take permissions to access the device's location");
      }
    } else {
      await getCurrentLoc();
    }
  }

  updateLocation(LatLng position) async{
    List newPlace =  await placemarkFromCoordinates(position.latitude, position.longitude);;
    Placemark placeMark  = newPlace[0];
    String compeletAddressInfor = '${placeMark.subThoroughfare} ${placeMark.thoroughfare}, ${placeMark.subLocality} ${placeMark.locality}, ${placeMark.subAdministrativeArea} ${placeMark.administrativeArea}, ${placeMark.postalCode} ${placeMark.country},';
    String specificAddress = '${placeMark.subLocality}, ${placeMark.country}';
    Logger().d("latitude: ${position.latitude} - longitude: ${position.longitude}");
    Logger().d("new locatio name $specificAddress");
    newPostion.onUpdateData(position);
    location.text = compeletAddressInfor;
  }

}