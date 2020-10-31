import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';

class NearByMe extends StatefulWidget {

  @override
  _NearByMeState createState() => _NearByMeState();
}

class _NearByMeState extends State<NearByMe> {
  Firestore _firestore = Firestore.instance;
  final Strategy strategy = Strategy.P2P_STAR;
  FirebaseUser loggedInUser;
  String testText = '';
  final _auth = FirebaseAuth.instance;
  List<dynamic> contactTraces = [];

  void discovery() async {
    try {
      print("Here0");
      print(loggedInUser.phoneNumber);
      print("Here1");
      bool a = await Nearby().startDiscovery(loggedInUser.phoneNumber, strategy,
          onEndpointFound: (id, name, serviceId) async {
            
      print("h");
        print('I saw id:$id with name:$name'); // the name here is an phoneNumber

        var docRef =
            _firestore.collection('users').document(loggedInUser.phoneNumber);

        //  When I discover someone I will see their phoneNumber
        docRef.collection('met_with').document(name).setData({
          'username': await getUsernameOfEmail(phoneNumber: name),
        });
      }, onEndpointLost: (id) {
        print(id);
      });
      print('DISCOVERING: ${a.toString()}');
    } catch (e) {
      print(e);
    }
  }

  void getPermissions() {
    Nearby().askLocationAndExternalStoragePermission();
  }

  Future<String> getUsernameOfEmail({String phoneNumber}) async {
    String res = '';
    await _firestore.collection('users').document(phoneNumber).get().then((doc) {
      if (doc.exists) {
        res = doc.data['username'];
      } else {
        // doc.data() will be undefined in this case
        print("No such document!");
      }
    });
    return res;
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void addContactsToList() async {
    await getCurrentUser();
    _firestore
        .collection('users')
        .document(loggedInUser.phoneNumber)
        .collection('met_with')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.documents) {
        String currUsername = doc.data['username'];

        if (!contactTraces.contains(currUsername)) {
          contactTraces.add(currUsername);
        }
      }
      setState(() {});
      print(loggedInUser.phoneNumber);
    });
  }

  @override
  void initState() {
    super.initState();
    addContactsToList();
    getPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
          color: Colors.deepPurple[800],
        ),
        centerTitle: true,
        title: Text(
          'TracerX',
          style: TextStyle(
            color: Colors.deepPurple[800],
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                bottom: 10.0,
                top: 30.0,
              ),
              child: Container(
                height: 100.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[500],
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 4.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Image(
                        image: AssetImage('images/corona.png'),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Your Contact Traces',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 21.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              elevation: 5.0,
              color: Colors.deepPurple[400],
              onPressed: () async {
                try {
                  bool a = await Nearby().startAdvertising(
                    loggedInUser.phoneNumber,
                    strategy,
                    onConnectionInitiated: null,
                    onConnectionResult: (id, status) {
                      print(status);
                    },
                    onDisconnected: (id) {
                      print('Disconnected $id');
                    },
                  );

                  print('ADVERTISING ${a.toString()}');
                } catch (e) {
                  print(e);
                }
                print("here");
                discovery();
              },
              child: Text(
                'Start Tracing',
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: Text(contactTraces[index]),
                  );
                },
                itemCount: contactTraces.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: Integrate nearby_api and Nearby_interface.
// TODO: Take mobile number instead of phoneNumber
