import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:template/features/coffee/home/home_viewModel.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';

class MapsViewModel {
  GenericCubit<Set<Marker>> markers = GenericCubit(Set<Marker>()); // Initialize with an empty set

  Future<List<Map<String, dynamic>>> getAllCoffeeShops() async{
    try{
      markers.onLoadingState();
      HomeViewModel viewModel = HomeViewModel();
      List<CoffeeShope> data =
          await viewModel.getAllCoffeeShopsWithReturnData();
      List<Map<String, dynamic>> locations = [];
      data.forEach((e) {
        locations.add({'name': e.name, 'lat': e.lat, 'lng': e.long});
      });
      return locations;
    }catch (e) {
      print("load markers Error $e");
      markers.onUpdateData([const Marker(markerId: MarkerId(""))].toSet());
      return [];
    }
  }

  // Add markers based on a list of locations
  void loadMarkers(List<Map<String, dynamic>> locations) async {
    try{
      final BitmapDescriptor markerIcon = await _createMarkerImageFromAsset(
          Resources.coffee);
      Set<Marker> markerSet = locations.map((location) {
        return Marker(
          markerId: MarkerId(location['name']),
          position: LatLng(location['lat'], location['lng']),
          infoWindow: InfoWindow(title: location['name']),
          icon: markerIcon, // Set the custom icon here
        );
      }).toSet();

      markers.onUpdateData(markerSet); // Emit the set of markers
    } catch (e){
      print("load markers Error $e");
      markers.onUpdateData([const Marker(markerId: MarkerId(""))].toSet());
    }
  }

  Future<BitmapDescriptor> _createMarkerImageFromAsset(String path) async {
    // Load an image from assets and create a BitmapDescriptor
    final byteData = await rootBundle.load(path);
    final buffer = byteData.buffer.asUint8List(); // Correct way to convert to Uint8List
    return BitmapDescriptor.fromBytes(buffer);
  }
}
