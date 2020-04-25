import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gocorona/Models/newsmodel.dart';
import 'package:gocorona/Screens/Donate.dart';
import 'package:gocorona/Services/news.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:gocorona/Screens/NearbyMe.dart';
import 'package:gocorona/Screens/Login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ArtContent> articles;
  
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    initialise();
  }
  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }
  Future _showNotificationWithDefaultSound() async {
    print("HERE");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Post',
      'How to Show Notification in Flutter',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
  void initialise() async {
    List<ArtContent> _temp = await News().getNews();
    setState(() {
      articles = _temp;
       print("HI");
      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project   
      // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
      var initializationSettingsAndroid =
          new AndroidInitializationSettings('app_icon'); 
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);
    });
  }

  @override
  Widget build(BuildContext context) {
    return articles != null
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                'Home',
                style: TextStyle(color: Colors.black),
              ),
              leading: IconButton(
                icon: const Icon(Icons.monetization_on),
                onPressed: () { 
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Donate()));
                            
                },
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0.0,
            ),
            body: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[],
                  ),
                ),
                FloatingActionButton(
                  child: Icon(Icons.local_drink),
                  onPressed:  (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                    
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: articles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                              onTap: () => {launchUrl(articles[index].newsUrl)},
                              child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Stack(
                                    children: <Widget>[
                                      Image.network(
                                          articles[index].newsimage.toString(),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.6),
                                          colorBlendMode: BlendMode.modulate),
                                      Positioned.fill(
                                          child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 5),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(articles[index].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 15)),
                                        ),
                                      ))
                                    ],
                                  ))));
                    },
                  ),
                )
              ],
            ))
        : Scaffold(
            body: Center(
              child: Loading(indicator: BallPulseIndicator(), size: 100.0, color: Colors.blue,),
            ),
          );
  }
}

void launchUrl(url) async {
  print(url);
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
