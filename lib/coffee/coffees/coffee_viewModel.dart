import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:template/features/admin/home/models/Category.dart';
import 'package:template/features/coffee/coffees/models/menu.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/network/firebase_helper.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/util/helper.dart';
import 'package:template/shared/util/ui.dart';
import 'package:uuid/uuid.dart';

class CoffeeViewModel{
  FirebaseHelper firebaseHelper = FirebaseHelper();
  GenericCubit<File?> imageFile = GenericCubit(null);
  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<List<Menu>> menus = GenericCubit([]);
  GenericCubit<List<Menu>> menusBaseOnCategoy = GenericCubit([]);
  GenericCubit<List<Menu>> allMenus = GenericCubit([]);
  GenericCubit<Category?> selectedCategory = GenericCubit(null);

  final formKey = GlobalKey<FormState>();

  TextEditingController search = TextEditingController(text: "");

  TextEditingController name = TextEditingController(text: "");
  TextEditingController price = TextEditingController(text: "");
  TextEditingController poromotion = TextEditingController(text: "0");
  TextEditingController description = TextEditingController(text: "");

  String imageUpdateURL = "";

  // Function to pick an image from the device
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.onUpdateData(File(pickedFile.path));
    }
  }

  addMenu(CoffeeShope coffeeShop) async{
    if (!formKey.currentState!.validate()){
      return;
    }

    if(imageFile.state.data == null){
      UI.showMessage("Upload Menu image");
      return;
    }

    Menu serv = Menu();
    String coffeeId = Uuid().v4(); // Generate a unique ID for the service

    try {
      loading.onLoadingState();
      loading.onUpdateData(true);
      String urlMenuImage = await firebaseHelper.uploadImage(
          imageFile.state.data ?? File(""));

      serv.id = coffeeId;
      serv.name = name.text;
      serv.price = double.parse(price.text);
      serv.poromotion = double.parse(poromotion.text);
      serv.description = description.text;
      serv.coffeeShopId = coffeeShop.id;
      serv.coffeShopData = coffeeShop;
      serv.categoryId = selectedCategory.state.data?.id;
      serv.categoryData = selectedCategory.state.data;
      serv.image = urlMenuImage;
      serv.ownerId = PrefManager.currentUser?.id;
      serv.ownerData = PrefManager.currentUser;

      QuerySnapshot? querySnapshot = await firebaseHelper.addDocumentWithSpacificDocID(CollectionNames.menuTable, coffeeId, serv.toJson());
      querySnapshot?.docs.forEach((e){
        print("e.data()");
        print(e.data());
      });
      UI.showMessage("Menu added success");
      getAllMenusByCoffeeShopID(coffeeShop.id ??"");
      loading.onUpdateData(false);
      UI.pop();
    }catch (e){
      loading.onUpdateData(false);
      print("add menu exception  >>>   $e");
    }
  }

  fillData(Menu a) async{
    name.text = a.name!;
    price.text = a.price.toString();
    poromotion.text = a.poromotion.toString();
    selectedCategory.onUpdateData(a.categoryData);
    description.text = a.description!;
    imageUpdateURL = a.image!;
    imageFile.onUpdateData(await Helper.getImageFileByUrl(a.image!));
  }

  updateMenu(CoffeeShope coffeeShop,String coffeeId) async{
    if (!formKey.currentState!.validate()){
      return;
    }

    if(imageFile.state.data == null){
      UI.showMessage("Upload Menu image");
      return;
    }

    Menu serv = Menu();

    try {
      loading.onLoadingState();
      loading.onUpdateData(true);
      String urlMenuImage = await firebaseHelper.updateImage(
          imageFile.state.data ?? File(""),
        imageUpdateURL
      );

      serv.id = coffeeId;
      serv.name = name.text;
      serv.price = double.parse(price.text);
      serv.poromotion = double.parse(poromotion.text);
      serv.poromotion = double.parse(poromotion.text);
      serv.description = description.text;
      serv.coffeeShopId = coffeeShop.id;
      serv.coffeShopData = coffeeShop;
      serv.categoryId = selectedCategory.state.data?.id;
      serv.categoryData = selectedCategory.state.data;
      serv.image = urlMenuImage;
      serv.ownerId = PrefManager.currentUser?.id;
      serv.ownerData = PrefManager.currentUser;

     await firebaseHelper.updateDocument(CollectionNames.menuTable, coffeeId, serv.toJson());
      UI.showMessage("Menu updated success");
      getAllMenusByCoffeeShopID(coffeeShop.id ??"");
      loading.onUpdateData(false);
      UI.pop();
    }catch (e){
      loading.onUpdateData(false);
      print("update menu exception  >>>   $e");
    }
  }

  deleteMenu(String menuId) async{
    try {
      loading.onLoadingState();
      loading.onUpdateData(true);
      await firebaseHelper.deleteDocument(CollectionNames.menuTable, menuId);
      UI.showMessage("Menu deleted success");
      loading.onUpdateData(false);
    }catch (e){
      loading.onUpdateData(false);
      print("delete menu exception  >>>   $e");
    }
  }

  getAllMenusByCoffeeShopID(String coffee_shop_id) async{
    try {
      menus.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.menuTable, "coffee_shop_id", coffee_shop_id);
      List<Menu> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(Menu.fromJson(res.data() as Map<String, dynamic>));
      });
      menus.onUpdateData(servs);
    }catch (e){
      menus.onUpdateData([]);
      print("menus exception  >>>   $e");
    }
  }

  getAllMenusByCategoryID(String category_id) async{
    try {
      menus.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.menuTable, "category_id", category_id);
      List<Menu> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(Menu.fromJson(res.data() as Map<String, dynamic>));
      });
      menus.onUpdateData(servs);
    }catch (e){
      menus.onUpdateData([]);
      print("menus exception  >>>   $e");
    }
  }


  getAllMenusByCategoryName(String category_name) async{
    try {
      print("${category_name}d");
      menus.onLoadingState();
      menusBaseOnCategoy.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.menuTable, "category_data.name", category_name);
      List<Menu> servs = [];
      print("Results >>> ${results.length}");
      results.forEach((res){
        print(res.data());
        servs.add(Menu.fromJson(res.data() as Map<String, dynamic>));
      });
      menus.onUpdateData(servs);
      print("servs count >>>> ${servs.length}");
      menusBaseOnCategoy.onUpdateData(servs);
    }catch (e){
      menus.onUpdateData([]);
      menusBaseOnCategoy.onUpdateData([]);
      print("menus exception  >>>   $e");
    }
  }

  getAllMenusByOwnerID(String owner_id) async{
    try {
      menus.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.menuTable, "ownerId", owner_id);
      List<Menu> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(Menu.fromJson(res.data() as Map<String, dynamic>));
      });
      menus.onUpdateData(servs);
    }catch (e){
      menus.onUpdateData([]);
      print("menus exception  >>>   $e");
    }
  }

  Future<List<Menu>> getAllMenus() async{
    try {
      allMenus.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.getAllDocuments(CollectionNames.menuTable);
      List<Menu> servs = [];
      results.forEach((res){
        print( res.data());
        servs.add(Menu.fromJson(res.data() as Map<String, dynamic>));
      });
      allMenus.onUpdateData(servs);
      print("servs.length");
      print(servs.length);
      return servs;
    }catch (e){
      allMenus.onUpdateData([]);
      print("allMenus exception  >>>   $e");
      return [];
    }
  }
}