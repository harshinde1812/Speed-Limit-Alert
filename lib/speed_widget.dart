import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:location/location.dart';
import 'package:map_project/speed%20.dart';
import 'package:map_project/speedWarning.dart';

Widget finalWidget = speedWidget;
double speedLimit = 0;
Widget limitWidget = const Center(
  child: AlertDialog(
    backgroundColor: Colors.redAccent,
    title: Text("Warning"),
    content: Text("You are over speeding"),
  ),
);
Widget speedWidget = StreamBuilder(
  stream: location.onLocationChanged,
  builder: (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
    int speedInKm = (snapshot.data!.speed! * 3.6).toInt();
    if (speedInKm > speedLimit-5 &&
        speedInKm < speedLimit &&
        speedInKm != 0) {
      FlutterRingtonePlayer().play(
        fromAsset: "assets/ringtone/exceeded.mpeg",
        volume: 1,
      );
    } else if (speedInKm > speedLimit && speedInKm != 0 && speedLimit != 0) {
      FlutterRingtonePlayer().play(
        fromAsset: "assets/ringtone/approaching.mpeg",
        volume: 1,
      );
    }
    if (snapshot.hasData) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 400,
                  margin: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    shape: BoxShape.rectangle,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: Center(
                    child: ListTile(
                      title: const Text(
                        'Speed',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                        ),
                      ),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$speedInKm',
                            style: const TextStyle(
                              fontSize: 110, fontFamily: 'FontMain',
                              color: Colors.cyan,
                            ),
                          ),
                          const Text(
                            ' km/h',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                Container(
                  margin: EdgeInsets.all(20.0),
                  height: 200,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    shape: BoxShape.rectangle,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: Center(
                    child: ListTile(
                      title: const Text(
                        'Speed Limit',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                        ),
                      ),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$speedLimit',
                            style: const TextStyle(
                              fontSize: 110, fontFamily: 'FontMain',
                              color: Colors.red,
                            ),
                          ),
                          const Text(
                            ' km/h',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                Container(
                  margin: EdgeInsets.all(20.0),
                  height: 150,
                  width: 400,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    shape: BoxShape.rectangle,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: speedWarning(speedInKm),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const Center(
        child: Text('Speed: 0'),
      );
    }
  },
);
