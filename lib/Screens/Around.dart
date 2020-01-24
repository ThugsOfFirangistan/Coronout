import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gocorona/Widgets/AddStore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Around extends StatefulWidget {
  @override
  _AroundState createState() => _AroundState();
}

class _AroundState extends State<Around> {
  @override
  void initState() {
    super.initState();
    initialise();
  }

  void initialise() async {}

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Around',
          style: Theme.of(context).textTheme.title,
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: new Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddStore()))
          },
          label: Text('Add Store'),
          icon: Icon(Icons.store),
        ),
      ),
    );
  }
}
