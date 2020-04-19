import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:gocorona/Screens/Around.dart';
import 'package:gocorona/Screens/Home.dart';
import 'package:gocorona/Screens/Login.dart';
import 'package:gocorona/Screens/World.dart';
import 'package:gocorona/Screens/India.dart';
import 'package:gocorona/Screens/SymptomsPage.dart';
import 'package:gocorona/Screens/PreventionPage.dart';
import 'package:gocorona/Screens/Help.dart';
import 'package:gocorona/Welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_settings/app_settings.dart';

import 'package:vibration/vibration.dart';

void main() => runApp(Gocorona());

class Gocorona extends StatelessWidget {
  bool seen = false, login = false;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    seen = _seen;
    await prefs.setBool('seen', true);
  }

  Future checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _login = (prefs.getBool('login') ?? false);
    print("login $_login");
    login = _login;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/symptoms': (context) => SymptomsPage(),
        '/prevention': (context) => PreventionPage(),
        '/homepage': (context) => MyStatefulWidget(),
        '/loginpage': (context) => Login(),
      },
      home: seen ? Welcome() : login ? Login() : MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  void initState() {
    super.initState();
    _checkBt();
  }

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  bool isbton = false, isnear = false;
  int cnt = 0;
  scanForDevices() {
    flutterBlue.startScan();
    flutterBlue.scanResults.listen((results) {
      if (results.length != 0 && cnt == 0) {
        for (ScanResult r in results) {
          print('${r.device.id} found! rssi: ${r.rssi} ');
          setState(() {
            isnear = true;
          });
          alertUsingVibrations(r.rssi, -69);
          cnt++;
        }
      }
    });
  }

  alertUsingVibrations(int rssi, int txPower) {
    //social distancing
    double distance = pow(10, ((txPower - rssi) / (10 * 2)));
    if (distance <= 1.8 && cnt == 0) {
      Vibration.vibrate(
          pattern: [100, 2000, 100, 2000], intensities: [128, 150]);
      cnt++;
    }
  }

  void _checkBt() {
    flutterBlue.state.listen((state) {
      if (state == BluetoothState.on) {
        setState(() {
          isbton = true;
        });
        scanForDevices();
      }
    });
  }

  int _selectedIndex = 2;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);
  List<Widget> _widgetOptions = [Help(), Around(), Home(), India(), World()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: !isbton
            ? _btAlert()
            : isnear
                ? _devNear(context)
                : _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            title: Text('Help'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.near_me),
            title: Text('Around'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            title: Text('India'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            title: Text('World'),
          ),
        ],
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        selectedIconTheme: IconThemeData(size: 40, color: Colors.black),
      ),
    );
  }

  Widget _btAlert() {
    return AlertDialog(
      title: Text("Bluetooth off"),
      content: Text("Turn on bluetooth for social distancing alert."),
      backgroundColor: Colors.white,
      actions: [
        FlatButton(
          child: Text("Turn on"),
          onPressed: () {
            AppSettings.openBluetoothSettings();
            _checkBt();
          },
        ),
      ],
    );
  }

  Widget _devNear(BuildContext context) {
    print("aaya");
    return Scaffold(
        body: AlertDialog(
      title: Text("Social Alert"),
      content: Text("Please keep at least 6ft distance."),
      backgroundColor: Colors.white,
      actions: [
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            Vibration.cancel();
            setState(() {
              isnear = false;
            });
          },
        ),
      ],
    ));
  }
}
