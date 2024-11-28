import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:template/features/Customer/maps/maps_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  MapsViewModel viewModel = MapsViewModel();

  getData() async{
    viewModel.loadMarkers(await viewModel.getAllCoffeeShops());
  }

  @override
  void initState() {
    super.initState();
    // Load markers into the Cubit for Eastern Saudi cities
   getData();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eastern Saudi Arabia Map'),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: AppSize.navBarHeight),
        child: BlocBuilder<GenericCubit<Set<Marker>>, GenericCubitState<Set<Marker>>>(
          bloc: viewModel.markers, // Provide the Cubit
          builder: (context, state) {
            if (state is GenericLoadingState) {
              return Loading();
            } else if (state.data.isNotEmpty) {
              return GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(26.4207, 50.0888), // Centered on Dammam
                  zoom: 11.0,
                ),
                markers: state.data, // Use the loaded markers
              );
            } else {
              return Center(child: Text('No markers available'));
            }
          },
        ),
      ),
    );
  }
}
