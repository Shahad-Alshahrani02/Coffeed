import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:template/features/Customer/rating/models/rating.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/network/firebase_helper.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';

class RatingViewModel {
  FirebaseHelper firebaseHelper = FirebaseHelper();

  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<List<Rating>> ratings = GenericCubit([]);
  GenericCubit<List<Rating>> allRatings = GenericCubit([]);

  addRating(Rating rating) async{
    try {
      loading.onLoadingState();
      loading.onUpdateData(true);
      QuerySnapshot? querySnapshot = await firebaseHelper.addDocumentWithSpacificDocID(CollectionNames.ratingsTable, rating.id!, rating.toJson());
      querySnapshot?.docs.forEach((e){
        print("e.data()");
        print(e.data());
      });
      UI.showMessage("Rating added success");
      loading.onUpdateData(false);
      // UI.pushWithRemove(AppRoutes.customerStartPage);
    }catch (e){
      loading.onUpdateData(false);
      print("add ratings exception  >>>   $e");
    }
  }

  Future<List<Rating>> getAllRatingsByMenuItemID(String id) async{
    try {
      ratings.onLoadingState();
      print("menu_item_id");
      print(id);
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.ratingsTable, "menu_item_id", id);
      List<Rating> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(Rating.fromJson(res.data() as Map<String, dynamic>));
      });
      ratings.onUpdateData(servs);
      loading.onUpdateData(false);
      return servs;
    }catch (e){
      ratings.onUpdateData([]);
      loading.onUpdateData(false);
      print("Rating exception  >>>   $e");
      return [];
    }
  }

  getAllRatings() async{
    try {
      allRatings.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.getAllDocuments(CollectionNames.ratingsTable);
      List<Rating> servs = [];
      results.forEach((res){
        print( res.data());
        servs.add(Rating.fromJson(res.data() as Map<String, dynamic>));
      });
      allRatings.onUpdateData(servs);
    }catch (e){
      allRatings.onUpdateData([]);
      loading.onUpdateData(false);
      print("Rating exception  >>>   $e");
    }
  }

}