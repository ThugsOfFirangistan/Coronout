import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    initialise();
  }

  void initialise() async {}

  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;

  Future<void> verifyPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('login', true);

    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text(
              'Enter SMS Code',
            ),
            content: Container(
              height: 100,
              child: Column(children: [
                TextField(
                  autofocus: true,
                  cursorColor: Colors.amber,
                  style: TextStyle(height: 2.0),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.amber,
                          style: BorderStyle.solid,
                        ),
                      ),
                      hintText: 'Enter OTP here'),
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _auth.currentUser().then((user) {
                    if (user != null) {
                      createRecord();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/homepage');
                    } else {
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  void createRecord() async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: phoneNo, password: "abc123");
          print(newUser);
    } catch (e) {
      print(e);
    }
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final AuthResult user = await _auth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.user.uid == currentUser.uid);
      createRecord();
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/homepage');
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Login',
            style: Theme.of(context).textTheme.title,
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 0.5 * MediaQuery.of(context).size.height,
                child: Image.asset(
                  "assets/images/login.png",
                  fit: BoxFit.fitHeight,
                ),
              ),
              Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                color: Colors.white,
                child: TextField(
                  onChanged: (value) {
                    this.phoneNo = "+91" + value;
                  },
                  style: TextStyle(
                      color: Colors.black, decoration: TextDecoration.none),
                  showCursor: false,
                  decoration: new InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      border: InputBorder.none,
                      hintText: 'Mobile Number',
                      hintStyle: TextStyle(color: Colors.black)),
                ),
              ),
              SizedBox(
                height: 0.05 * MediaQuery.of(context).size.height,
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                onPressed: () {
                  verifyPhone();
                },
                child: Text(
                  'Send OTP',
                  style: TextStyle(fontSize: 21),
                ),
                textColor: Colors.white,
                color: Colors.black,
                shape: StadiumBorder(),
              ),
            ],
          ),
        ));
  }
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];
