import "package:flutter/material.dart";
import "package:map_project/speed%20.dart";
import "package:permission_handler/permission_handler.dart";

import "map.dart";
bool locationPermission = false;
int _currentIndex = 1;
List<Widget> _children = [
  const MyApp(),
  const Speed(),
];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();
  }

  checkPermission() async {
    if (await Permission.location.isDenied) {
      await Permission.location.request();
      setState(() {
        locationPermission = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !locationPermission
            ? _children[_currentIndex]
            : const Center(
                child: Text("Please enable location permission"),
              ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.speed),
              label: 'Speed',
            ),
          ],
        ));
  }
}
