import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gocorona/Widgets/AddStore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gocorona/Services/groceries.dart';
import 'package:gocorona/Models/grocerymodel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class Around extends StatefulWidget {
  @override
  _AroundState createState() => _AroundState();
}

class _AroundState extends State<Around> {
  List<Store> stores;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position currentLocation;
  final double _initFabHeight = 70.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 50.0;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fabHeight = _initFabHeight;
    initialise();
  }

  void initialise() async {
    List<Store> _lst = await getStores();
    setState(() {
      stores = _lst;
    });
    for (int i = 0; i < stores.length; i++) {
      var markerIdVal = markers.length + 1;
      String mar = markerIdVal.toString();
      final MarkerId markerId = MarkerId(mar);
      LatLng latLng = new LatLng(stores[i].lat, stores[i].lng);
      final Marker marker = Marker(markerId: markerId, position: latLng);

      setState(() {
        markers[markerId] = marker;
      });
    }
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        currentLocation = position;
      });
    }).catchError((e) {
      print(e);
    });
    print(currentLocation);
  }

  GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    _panelHeightOpen = MediaQuery.of(context).size.height * .50;
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
        body: currentLocation != null
            ? Stack(
                children: <Widget>[
                  SlidingUpPanel(
                      panelBuilder: (sc) => _panel(sc),
                      borderRadius: radius,
                      maxHeight: _panelHeightOpen,
                      minHeight: _panelHeightClosed,
                      onPanelSlide: (double pos) => setState(() {
                            _fabHeight =
                                pos * (_panelHeightOpen - _panelHeightClosed) +
                                    _initFabHeight;
                          }),
                      body: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(currentLocation.latitude,
                                  currentLocation.longitude),
                              zoom: 10),
                          onMapCreated: _onMapCreated,
                          markers: Set<Marker>.of(markers.values))),
                  Positioned(
                    right: 20.0,
                    bottom: _fabHeight,
                    child: FloatingActionButton.extended(
                      onPressed: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddStore()))
                      },
                      label: Text('Add Store'),
                      icon: Icon(Icons.store),
                    ),
                  ),
                ],
              )
            : Scaffold(
                body: Center(
                  child: Loading(
                    indicator: BallPulseIndicator(),
                    size: 100.0,
                    color: Colors.blue,
                  ),
                ),
              ));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Text("Nearby Stores",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 24.0,
                )),
              SizedBox(
              height: 15,
            ),  
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: stores.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  stores[index].name,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text("Operational Hours: " +
                                    stores[index].hours),
                              ],
                            )),
                        ListTile(
                          onTap: () => launch(
                              "google.navigation:q=${stores[index].lat},${stores[index].lng}"),
                          title: Text(
                            stores[index].address,
                            style: TextStyle(fontSize: 10),
                          ),
                          trailing: Icon(Icons.navigation),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
