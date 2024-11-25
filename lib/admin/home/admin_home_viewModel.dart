import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:template/features/admin/home/models/Category.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/network/firebase_helper.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/util/ui.dart';
import 'package:uuid/uuid.dart';

class AdminHomeViewModel{
  FirebaseHelper firebaseHelper = FirebaseHelper();

  final formKey = GlobalKey<FormState>();

  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<List<Category>> categories = GenericCubit([]);
  GenericCubit<List<Category>> allCategories = GenericCubit([]);
  GenericCubit<CoffeeShope?> selectedCoffee = GenericCubit(null);

  TextEditingController name = TextEditingController(text: "");

  addCategory() async{
    if (!formKey.currentState!.validate()){
      return;
    }
    
    if(selectedCoffee.state.data == null){
      UI.showMessage("Please select coffee shop");
    }

    Category serv = Category();
    String catId = Uuid().v4(); // Generate a unique ID for the service

    try {
      loading.onLoadingState();
      loading.onUpdateData(true);
      serv.id = catId;
      serv.name = name.text;
      serv.coffeeShopId = selectedCoffee.state.data?.id;

      QuerySnapshot? querySnapshot = await firebaseHelper.addDocumentWithSpacificDocID(CollectionNames.categoriesTable, catId, serv.toJson());
      querySnapshot?.docs.forEach((e){
        print("e.data()");
        print(e.data());
      });
      UI.showMessage("Category added success");
      loading.onUpdateData(false);
    }catch (e){
      loading.onUpdateData(false);
      print("add cateogries exception  >>>   $e");
    }
  }

  getAllCategoriesByCoffeeShopID(String coffee_shop_id) async{
    try {
      categories.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.categoriesTable, "coffee_shop_id", coffee_shop_id);
      List<Category> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(Category.fromJson(res.data() as Map<String, dynamic>));
      });
      categories.onUpdateData(servs);
    }catch (e){
      categories.onUpdateData([]);
      loading.onUpdateData(false);
      print("coffeeshopes exception  >>>   $e");
    }
  }

  getAllCategories() async{
    try {
      allCategories.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.getAllDocuments(CollectionNames.categoriesTable);
      List<Category> servs = [];
      results.forEach((res){
        print( res.data());
        servs.add(Category.fromJson(res.data() as Map<String, dynamic>));
      });
      allCategories.onUpdateData(servs);
    }catch (e){
      allCategories.onUpdateData([]);
      loading.onUpdateData(false);
      print("allCategories exception  >>>   $e");
    }
  }

}