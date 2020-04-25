import 'package:flutter/material.dart';
import 'package:gocorona/Models/indiamodel.dart';
import 'package:gocorona/Services/ireports.dart';

class Istats extends StatefulWidget {
  @override
  _IstatsState createState() => _IstatsState();
}

class _IstatsState extends State<Istats> {
  @override
  void initState() {
    super.initState();
    initialise();
  }

  List<StateWiseConfirmed> reports, stateWiseConfirmed;
  void initialise() async {
    List<StateWiseConfirmed> _stateCase =
        await IReport().getStateWiseTotalCases();
    setState(() {
      reports = _stateCase;
      stateWiseConfirmed = _stateCase;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image(image: AssetImage("assets/images/header.png")),
              Padding(
                padding: EdgeInsets.only(top:40),
                child: Center(
                  child: Text(
                "India",
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600),
              ),
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 0.2 * h),
                    width: 0.4 * w,
                    height: 0.2 * h,
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text(
                                "Confirmed",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    "${stateWiseConfirmed[0].confirmed}",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(top: 20, left: 5),
                                child: Icon(
                                  Icons.arrow_upward,
                                  size: 15,
                                  color: Colors.red,
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    "${stateWiseConfirmed[0].deltaconfirmed}",
                                    style: TextStyle(color: Colors.red),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0.2 * h),
                    width: 0.4 * w,
                    height: 0.2 * h,
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text(
                                "Active",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    "${stateWiseConfirmed[0].active}",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 0.42 * h),
                    width: 0.4 * w,
                    height: 0.2 * h,
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text(
                                "Recovered",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    "${stateWiseConfirmed[0].recovered}",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(top: 20, left: 5),
                                child: Icon(
                                  Icons.arrow_upward,
                                  size: 15,
                                  color: Colors.green,
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    "${stateWiseConfirmed[0].deltarecovered}",
                                    style: TextStyle(color: Colors.green),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0.42 * h),
                    width: 0.4 * w,
                    height: 0.2 * h,
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text(
                                "Deceased",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    "${stateWiseConfirmed[0].deaths}",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(top: 20, left: 5),
                                child: Icon(
                                  Icons.arrow_upward,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    "${stateWiseConfirmed[0].deltadeaths}",
                                    style: TextStyle(color: Colors.grey),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 0.02 * h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              children: <Widget>[
                Container(
                  width: 0.35 * w,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: Text(
                    "State/UT",
                    style: TextStyle(fontSize: 15),
                  )),
                  color: Colors.grey[100],
                ),
                Container(
                  margin: EdgeInsets.only(left: 4),
                  width: 0.15 * w,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: Text(
                    "C",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.w700),
                  )),
                  color: Colors.grey[100],
                ),
                Container(
                  margin: EdgeInsets.only(left: 4),
                  width: 0.15 * w,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: Text(
                    "A",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.w700),
                  )),
                  color: Colors.grey[100],
                ),
                Container(
                  margin: EdgeInsets.only(left: 4),
                  width: 0.12 * w,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: Text(
                    "R",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.w700),
                  )),
                  color: Colors.grey[100],
                ),
                Container(
                  margin: EdgeInsets.only(left: 4),
                  width: 0.12 * w,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: Text(
                    "D",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w700),
                  )),
                  color: Colors.grey[100],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stateWiseConfirmed.length - 1,
              itemBuilder: (BuildContext context, int index) {
                index += 1;
                return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 0.35 * w,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                              child: Text(
                            stateWiseConfirmed[index].state,
                            style: TextStyle(fontSize: 15),
                          )),
                          color: Colors.grey[100],
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          width: 0.15 * w,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                              child: Text(
                            stateWiseConfirmed[index].confirmed,
                            style: TextStyle(fontSize: 15),
                          )),
                          color: Colors.grey[100],
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          width: 0.15 * w,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                              child: Text(
                            stateWiseConfirmed[index].active,
                            style: TextStyle(fontSize: 15),
                          )),
                          color: Colors.grey[100],
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          width: 0.12 * w,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                              child: Text(
                            stateWiseConfirmed[index].recovered,
                            style: TextStyle(fontSize: 15),
                          )),
                          color: Colors.grey[100],
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          width: 0.12 * w,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                              child: Text(
                            stateWiseConfirmed[index].deaths,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          )),
                          color: Colors.grey[100],
                        ),
                      ],
                    ));
              },
            ),
          )
        ],
      ),
    );
  }
}
