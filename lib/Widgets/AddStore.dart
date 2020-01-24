import 'package:flutter/material.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:http/http.dart';
import 'dart:convert';

class AddStore extends StatefulWidget {
  @override
  _AddStoreState createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  String name = "";
  String phone = "";
  String ophrs = "";
  String address = "";
  String lat, lng;
  @override
  void initState() {
    super.initState();
    initialise();
  }

  void initialise() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'AddStore',
            style: Theme.of(context).textTheme.title,
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 0.9 * MediaQuery.of(context).size.width,
                  decoration: _containerDecoration(),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12.0, right: 12.0, top: 4),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Name",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0.0),
                        hintStyle: TextStyle(
                          color: Colors.grey[850],
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          name = text;
                        });
                      },
                      autofocus: false,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.grey[500],
                      ),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: SearchMapPlaceWidget(
                      apiKey: "Your key here",
                      onSelected: (Place place) async {
                        final geolocation = await place.geolocation;
                        List<String> cor =
                            geolocation.coordinates.toString().split(',');
                        lat = cor[0].substring(7);
                        lng = cor[1];
                        address = place.description;
                      })),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 0.9 * MediaQuery.of(context).size.width,
                  decoration: _containerDecoration(),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12.0, right: 12.0, top: 4),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Phone",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0.0),
                        hintStyle: TextStyle(
                          color: Colors.grey[850],
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          phone = text;
                        });
                      },
                      autofocus: false,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.grey[500],
                      ),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 0.9 * MediaQuery.of(context).size.width,
                  decoration: _containerDecoration(),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12.0, right: 12.0, top: 4),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Operational Hours",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0.0),
                        hintStyle: TextStyle(
                          color: Colors.grey[850],
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          ophrs = text;
                        });
                      },
                      autofocus: false,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.grey[500],
                      ),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                padding: EdgeInsets.all(10),
                onPressed: () {
                  postTest();
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ],
          ),
        ));
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(6.0)),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 10)
      ],
    );
  }

  postTest() async {
    final url = "http://35.225.123.48:8080/stores";
    var map = new Map<String, dynamic>();
    map['name'] = name;
    map['address'] = address;
    map['phone'] = phone;
    map['lat'] = lat;
    map['lng'] = lng;
    map['hours'] = ophrs;
    print(map);
    Response response = await post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(map),
    );
    print(response);
  }
}
