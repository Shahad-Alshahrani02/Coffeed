import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:template/features/coffee/advertisment/advertisment_page.dart';
import 'package:template/features/coffee/advertisment/models/advertisment.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/network/firebase_helper.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/helper.dart';
import 'package:template/shared/util/ui.dart';
import 'package:uuid/uuid.dart';

class AdvertismentViewModel{
  FirebaseHelper firebaseHelper = FirebaseHelper();
  GenericCubit<File?> imageFile = GenericCubit(null);
  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<List<Advertisment>> advertisments = GenericCubit([]);
  GenericCubit<List<Advertisment>> allAdvertisments = GenericCubit([]);
  GenericCubit<CoffeeShope?> selectedCoffeeShop = GenericCubit(null);
  GenericCubit<DateTime> startDate = GenericCubit(DateTime.now());
  GenericCubit<DateTime> endDate = GenericCubit(DateTime.now());

  final formKey = GlobalKey<FormState>();

  TextEditingController title = TextEditingController(text: "");
  TextEditingController price = TextEditingController(text: "1000");
  TextEditingController description = TextEditingController(text: "");

  String imageUpdatedUrl = "";

  // Function to pick an image from the device
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.onUpdateData(File(pickedFile.path));
    }
  }

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
        if (isStartDate) {
          startDate.onUpdateData(pickedDate);
        } else {
          endDate.onUpdateData(pickedDate);
        }
    }
  }

  addAdvertisement() async{
    if (!formKey.currentState!.validate()){
      return;
    }

    if(imageFile.state.data == null){
      UI.showMessage("Upload Advertisement image");
      return;
    }

    if(selectedCoffeeShop.state.data == null){
      UI.showMessage("Select coffee shop");
      return;
    }

    Advertisment serv = Advertisment();
    String advertId = Uuid().v4(); // Generate a unique ID for the service
    loading.onLoadingState();
    loading.onUpdateData(true);
    try {
      String urlImage = await firebaseHelper.uploadImage(
          imageFile.state.data ?? File(""));

      serv.id = advertId;
      serv.title = title.text;
      serv.price = double.parse(price.text);
      serv.description = description.text;
      serv.startDate = startDate.state.data;
      serv.endDate = endDate.state.data;
      serv.coffeeShopOwnerId = PrefManager.currentUser?.id;
      serv.coffeeShopOwnerData = PrefManager.currentUser;
      serv.coffeeShopData = selectedCoffeeShop.state.data;
      serv.coffeeShopId = selectedCoffeeShop.state.data?.id;
      serv.isApporved = false;
      serv.image = urlImage;

      QuerySnapshot? querySnapshot = await firebaseHelper.addDocumentWithSpacificDocID(CollectionNames.advertismentsTable, advertId, serv.toJson());
      querySnapshot?.docs.forEach((e){
        print("e.data()");
        print(e.data());
      });
      UI.showMessage("Advertisement added success");
      getAllAdvertisementForEveryUserID();
      loading.onUpdateData(false);
      UI.pop();
    }catch (e){
      loading.onUpdateData(false);
      print("add advertisements exception  >>>   $e");
    }
  }


  fillData(Advertisment a) async{
    print("a.coffeeShopData?.toJson()");
    print(a.coffeeShopData?.toJson());
    selectedCoffeeShop.onUpdateData(a.coffeeShopData);
    title.text = a.title!;
    price.text = a.price.toString();
    description.text = a.description!;
    startDate.onUpdateData(a.startDate!);
    endDate.onUpdateData(a.endDate!);
    imageUpdatedUrl = a.image!;
    imageFile.onUpdateData(await Helper.getImageFileByUrl(a.image!));
  }

  updateAdvertisement(String advertId) async{
    if (!formKey.currentState!.validate()){
      return;
    }

    if(imageFile.state.data == null){
      UI.showMessage("Upload Advertisement image");
      return;
    }

    if(selectedCoffeeShop.state.data == null){
      UI.showMessage("Select coffee shop");
      return;
    }

    Advertisment serv = Advertisment();
    loading.onLoadingState();
    loading.onUpdateData(true);
    try {
      String urlImage = await firebaseHelper.updateImage(
          imageFile.state.data ?? File(""),
          imageUpdatedUrl
      );

      serv.id = advertId;
      serv.title = title.text;
      serv.price = double.parse(price.text);
      serv.description = description.text;
      serv.startDate = startDate.state.data;
      serv.endDate = endDate.state.data;
      serv.coffeeShopOwnerId = PrefManager.currentUser?.id;
      serv.coffeeShopOwnerData = PrefManager.currentUser;
      serv.coffeeShopData = selectedCoffeeShop.state.data;
      serv.coffeeShopId = selectedCoffeeShop.state.data?.id;
      serv.image = urlImage;

      await firebaseHelper.updateDocument(CollectionNames.advertismentsTable, advertId , serv.toJson());
      UI.showMessage("Advertisement updated success");
      getAllAdvertisementForEveryUserID();
      loading.onUpdateData(false);
      UI.pop();
    }catch (e){
      loading.onUpdateData(false);
      print("update advertisements exception  >>>   $e");
    }
  }


  updateAdvertisementStatus(Advertisment advert, bool stats) async{
    loading.onLoadingState();
    loading.onUpdateData(true);
    try {
      advert.isApporved = stats;
      await firebaseHelper.updateDocument(CollectionNames.advertismentsTable, advert.id! , advert.toJson());
      UI.showMessage("Advertisement updated success");
      getAllAdvertisementsForAdmin();
      loading.onUpdateData(false);
    }catch (e){
      loading.onUpdateData(false);
      print("update advertisements exception  >>>   $e");
    }
  }


  deleteAdvertisement(String advertId) async{
    try {
      loading.onLoadingState();
      loading.onUpdateData(true);
      await firebaseHelper.deleteDocument(CollectionNames.advertismentsTable, advertId);
      UI.showMessage("Advertisement deleted success");
      getAllAdvertisementForEveryUserID();
      loading.onUpdateData(false);
    }catch (e){
      loading.onUpdateData(false);
      print("delete advertisements exception  >>>   $e");
    }
  }


  getAllAdvertisementForEveryUserID() async{
    try {
      advertisments.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.advertismentsTable, "coffee_shop_owner_id", PrefManager.currentUser!.id);
      List<Advertisment> servs = [];
      print(results);
      results.forEach((res){
        print(res.data());
        Advertisment advert = Advertisment.fromJson(res.data() as Map<String, dynamic>);
        if(advert.endDate?.isAfter(DateTime.now()) ?? false){
          if(advert.isApporved!){
            servs.add(advert);
          }
        }
      });
      advertisments.onUpdateData(servs);
    }catch (e){
      advertisments.onUpdateData([]);
      print("coffeeshopes exception  >>>   $e");
    }
  }

  getAllAdvertisements() async{
    try {
      allAdvertisments.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.getAllDocuments(CollectionNames.advertismentsTable);
      List<Advertisment> servs = [];
      results.forEach((res){
        print( res.data());
        Advertisment advert = Advertisment.fromJson(res.data() as Map<String, dynamic>);
       if(advert.endDate?.isAfter(DateTime.now()) ?? false){
         if(advert.isApporved!){
           servs.add(advert);
         }
       }
      });
      allAdvertisments.onUpdateData(servs);
    }catch (e){
      allAdvertisments.onUpdateData([]);
      print("allCoffeeShopes exception  >>>   $e");
    }
  }

  getAllAdvertisementsForAdmin() async{
    try {
      allAdvertisments.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.getAllDocuments(CollectionNames.advertismentsTable);
      List<Advertisment> servs = [];
      results.forEach((res){
        print( res.data());
        Advertisment advert = Advertisment.fromJson(res.data() as Map<String, dynamic>);
       if(advert.endDate?.isAfter(DateTime.now()) ?? false){
        servs.add(advert);
       }
      });
      allAdvertisments.onUpdateData(servs);
    }catch (e){
      allAdvertisments.onUpdateData([]);
      print("allCoffeeShopes exception  >>>   $e");
    }
  }

}