import 'package:flutter/material.dart';
import 'package:sandugo/HomePage.dart';
import 'package:sandugo/NearestFacilities.dart';
import 'package:sandugo/main.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  List<Widget> widgetOptions = <Widget>[
    FacilitiesPage(),
    Text("Saved Places"),
    Text("Information"), //For now cuz Empty pa ung account page
    Homepage(), //Home Page
  ];

  //Function to select on List
  void _onItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SanDUGO"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.home),
          tooltip: "Go Home",
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => Homepage()),
            );
          },
        ),
      ),
      body: Center(
        child: widgetOptions.elementAt(_currentIndex),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.call),
        onPressed: () {
          //Should redirect to Add Routine/Task
          print("Emergency Call");
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(Colors.white.value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop_outlined),
            activeIcon: Icon(Icons.pin_drop_sharp),
            label: "Find Blood",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outlined),
            activeIcon: Icon(Icons.bookmark_add_sharp),
            label: "Saved Places",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark_outlined),
            activeIcon: Icon(Icons.question_mark_sharp),
            label: "Information",
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTap, //Passing on Tap
      ),
    );
  }
}
