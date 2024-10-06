import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:location/location.dart';
import 'package:map_project/home.dart';
import 'package:map_project/speed_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import 'location_data.dart';
late LocationData locationData;
Location location = Location();
bool isClassified = false;
double normalSpeedLimit=30;
class Speed extends StatefulWidget {
  const Speed({super.key});

  @override
  State<Speed> createState() => _SpeedState();
}

class _SpeedState extends State<Speed> {
  int acceleration = 0;
  final dio = Dio();

  Timer? timer;

  @override
  void initState() {
    super.initState();
    print("Init State");
    enableLocation();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      print("Checking Road...");
      checkRoad();
    });
  }

  enableLocation() async {
    print("Enabling Location");
    if (await Permission.location.isDenied) {
      print("Location Permission Denied. Requesting...");
      await Permission.location.request();
      setState(() {
        locationPermission = true;
      });
    }
    location.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );
    locationData = await location.getLocation();
    print(
        "Location Enabled: ${locationData.latitude}, ${locationData.longitude}");
  }

  checkRoad() async {
    print("Checking Road...");
    final res = await dio.get(
        "https://roads.googleapis.com/v1/nearestRoads?points=${locationData.latitude}%2C${locationData.longitude}&key=${dotenv.env["GOOGLE_MAP"]}");
    print("Response: $res");
    print("Place ID: ${res.data["snappedPoints"][0]["placeId"]}");
    var placeId = res.data["snappedPoints"][0]["placeId"];
    for (int i = 0; i < locationDataPoints.length; i++) {
      if (locationDataPoints[i].placeId == placeId) {
        print("You are on the classified road");
        isClassified = true;
        if (locationData.speed! > locationDataPoints[i].speedLimit - 5) {
          print("You are over speeding on classified road");
          setState(() {
            speedLimit=locationDataPoints[i].speedLimit;
            finalWidget = limitWidget;
          });
        } else {
          print("You are not over speeding on classified road");
          print("You are on the classified road");
          setState(() {
            speedLimit=locationDataPoints[i].speedLimit;
            finalWidget = speedWidget;
          });
        }
      }
    }
    if (!isClassified) {
      print("You are not on the classified road");
      if (locationData.speed! >= normalSpeedLimit) {
        print("You are over speeding on unclassified road");
        setState(() {
          speedLimit=normalSpeedLimit;
          FlutterRingtonePlayer().playAlarm(
            volume: 1,
          );
          finalWidget = limitWidget;
        });
      } else {
        print("You are not over speeding on unclassified road");
        setState(() {
          speedLimit=normalSpeedLimit;
          finalWidget = speedWidget;
        });
      }
    } else {
      isClassified = false;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: locationPermission
          ? const Center(
              child: Text("Please enable location permission"),
            )
          : finalWidget,
    );
  }
}
