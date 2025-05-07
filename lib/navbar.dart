import 'package:flutter/material.dart';
import 'package:sandugo/main.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  List<Widget> widgetOptions = <Widget> [
    HomePage(),
    Text("Explore"),
    Text("Saved Places"),
    //Text('Account'),
    Text("Information")//For now cuz Empty pa ung account page
   ];

  //Function to select on List
   void _onItemTap(int index){
    setState(() {
      _currentIndex = index;
    });
   }
   
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
        child: widgetOptions.elementAt(_currentIndex),
        ),
        floatingActionButton: FloatingActionButton(child: Icon(Icons.call),
        onPressed: () {
          //Should redirect to Add Routine/Task
          print("Emergency Call");
        },
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromRGBO(238, 233, 255, 100),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.pin_drop_outlined),
              activeIcon: Icon(Icons.pin_drop_sharp),
              label: "Explore",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flag_outlined),
              activeIcon: Icon(Icons.flag_circle_sharp),
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