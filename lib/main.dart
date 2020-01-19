import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FlutterClock(),
    );
  }
}

class FlutterClock extends StatefulWidget {
  @override
  _FlutterClockState createState() => _FlutterClockState();
}

class _FlutterClockState extends State<FlutterClock> {
  DateTime _now = DateTime.now();
  double angle = 0;
  double angleMinute = 0;
  double angleHour = 0;
  int prevSec = 0;
  int sec = 0;
  int mill = 0;
  int preHour = 0;
  int nowHour = 0;
  var w, h;
  var ws, wm, wh;
  var off_x, off_y;
  String day = "", date1 = "", date2 = "";
  double zoomout = 0;
  String ampm = "images/coffee.png";

  @override
  void initState() {
    Timer.periodic(Duration(milliseconds: 105), (v) {
      setState(() {
        _now = DateTime.now();
        day = DateFormat('EEEE').format(_now);
        date1 = DateFormat('d').format(_now);
        date2 = DateFormat('MMM').format(_now);
//Calculating Degree for seconds
        int sec = _now.second;
        if (_now.second != prevSec) mill = _now.millisecond;
        angle = double.parse(_now.second.toString() +
                '.' +
                (_now.millisecond - mill).toString()) *
            pi /
            30;
        prevSec = _now.second;
//Calculating degree for mintues
        angleMinute =
            ((_now.second + _now.minute * 60 + _now.millisecond / 1000) / 10 +
                    126.3) *
                pi /
                180;

//Caluculating degree for hour
        nowHour = _now.hour;
        if (nowHour != preHour) {
          angleHour = nowHour * 30 * pi / 180;
          preHour = nowHour;
        }
// Getting AM-PM
        if (DateFormat('a').format(_now) == 'PM')
          ampm = 'images/beer.png';
        else
          ampm = 'images/coffee.png';
        print(DateFormat('a').format(_now));
      });
    });
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    zoomout = 0.09;
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    ws = (2 * 74 * w / 55) * (1 - zoomout);
    wm = ws * 63 / 74;
    wh = ws * 52 / 74;
    off_x = w * 0.07;
    off_y = w * 0.17;

    return Scaffold(
        backgroundColor: Color(0xffeaeaea),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
//SECOND
              Positioned(
                bottom: -ws / 2 + w * 0.15 - ws * zoomout / 2 + off_y,
                right: 2 * w / 5 - w * 0.06 + ws * zoomout / 2 - off_x,
                child: Transform.rotate(
                  angle: -angle,
                  // angle: 0,
                  child: Image.asset(
                    'images/seconds_face.png',
                    height: ws,
                  ),
                ),
              ),

// MINUTE
              Positioned(
                bottom: -wm / 2 + w * 0.15 - wm * zoomout / 2 + off_y,
                right: 3 * w / 5 - w * 0.06 + wm * zoomout / 2 - off_x,
                child: Transform.rotate(
                  angle: 126 * pi / 180 - angleMinute,
                  child: Image.asset(
                    'images/minutes_face.png',
                    height: wm,
                  ),
                ),
              ),

//HOUR
              Positioned(
                bottom: -wh / 2 + w * 0.15 - wh * zoomout / 2 + off_y,
                right: 4 * w / 5 - w * 0.06 + wh * zoomout / 2 - off_x,
                child: Transform.rotate(
                  angle: -angleHour,
                  child: Image.asset(
                    'images/hours_face.png',
                    height: wh,
                  ),
                ),
              ),

// overlay hour
              Positioned(
                child: Image.asset(
                  'images/overlay.png',
                  height: h * 0.3 * (1 - zoomout),
                ),
                bottom: off_y,
                left: off_x,
              ),

// overlay minute
              Positioned(
                child: Image.asset(
                  'images/overlay.png',
                  height: h * 0.3 * (1 - zoomout),
                ),
                bottom: off_y,
                left: w / 5 * (1 - zoomout) + off_x,
              ),

// overlay second
              Positioned(
                child: Image.asset(
                  'images/overlay.png',
                  height: h * 0.3 * (1 - zoomout),
                ),
                bottom: off_y,
                left: 2 * w / 5 * (1 - zoomout) + w * 0.01 + off_x,
              ),

//TIME STAMP
              Positioned(
                top: 50,
                right: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      day,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: w / 10 / 66 * 40,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          // margin: EdgeInsets.fromLTRB(w * 0.02, 0, 0, 0),
                          child: Text(
                            date1,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: w / 10,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, w * 0.015),
                          child: Text(
                            date2,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: w / 10 / 66 * 24,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      child: Image.asset(
                        ampm,
                        height: w * 0.085,
                      ),
                      margin: EdgeInsets.fromLTRB(0, w * 0.05, 0, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
