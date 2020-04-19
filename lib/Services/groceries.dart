import 'dart:convert';
import 'package:http/http.dart';
import 'package:gocorona/Models/grocerymodel.dart';

final url = "http://35.225.123.48:8080/stores";

Future<List<Store>> getStores() async {
  List<Store> reports = [];
  try {
    Response response = await get(url);
    List data = jsonDecode(response.body);
    for (int i = 0; i < data.length; i++) {
      Store _store = new Store(
          name: data[i]["name"], address: data[i]["address"], lat: data[i]["lat"], lng: data[i]["lng"], hours: data[i]["hours"]);
      reports.add(_store);
    }
  } catch (e) {
    print("Error");
    print(e);
  }
  return reports;
}
