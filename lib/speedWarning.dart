import "package:flutter/material.dart";

import "package:map_project/speed_widget.dart";

Widget speedWarning(int speedInKm) {
  if (speedInKm > speedLimit - 5 && speedInKm != 0 && speedInKm < speedLimit) {
    return const Center(
      child: Text(
        "Approaching Speed Limit",
        style: TextStyle(
          fontSize: 40,fontFamily: 'FontMain',
          color: Colors.red,
        ),
      ),
    );
  } else if (speedInKm != 0 && speedInKm > speedLimit && speedLimit != 0) {
    return const Center(
      child: Text(
        "EXCEEDING SPEED LIMIT",
        style: TextStyle(
          fontSize: 40,fontFamily: 'FontMain',
          color: Colors.red,
        ),
      ),
    );
  } else if (speedInKm < speedLimit && speedInKm != 0) {
    return const Center(
      child: Text(
        "Driving Safely",
        style: TextStyle(
          fontSize: 40, fontFamily: 'FontMain',
          color: Colors.green,
        ),
      ),
    );
  } else {
    return const Text(
      "DRIVE SAFELY",
      style: TextStyle(
        fontSize: 40, fontFamily: 'FontMain',
        color: Colors.cyan,
      ),
    );
  }
}
