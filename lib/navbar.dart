import 'package:flutter/material.dart';
import 'package:sandugo/FindBloodPage.dart';
import 'package:sandugo/HomePage.dart';
import 'package:sandugo/NearestFacilities.dart';
import 'package:sandugo/main.dart';
import 'package:sandugo/InformationPage.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
   bool _isFirstLoad = true;
   bool _showNearestFacilities= false;
  

  List<Widget> widgetOptions = <Widget>[
    FindBloodPage(),
    Text("Saved Places"),
    InformationPage(), // <-- Use your actual InformationPage here
  ];

  final List<String> pageTitles = [
    "Filters",
    "Saved Places",
    "FAQs",
  ];

  //Function to select on List
  void _onItemTap(int index) {
    setState(() {
      _currentIndex = index;
      _isFirstLoad = false;
      _showNearestFacilities = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Determine Which Page to load
    Widget bodyContent;
    if (_showNearestFacilities) {
      bodyContent = FacilitiesPage();
    } else if (_isFirstLoad) {
      bodyContent = Homepage(
        onFindBloodTap: () {
          setState(() {
            _currentIndex = 0; // FindBloodPage
            _isFirstLoad = false;
          });
        },
        onNearestFacilitiesTap: () {
          setState(() {
            _showNearestFacilities = true;
          });
        },
        onInformationPageTap: () {
          setState(() {
            _currentIndex = 2; // Information
            _isFirstLoad = false;
          });
        },
      );
    } else {
      bodyContent = widgetOptions.elementAt(_currentIndex);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBEAEA),
        elevation: 0,
        centerTitle: true,
        // Changing Page Titles depending on the pages
        title: Text(
          _showNearestFacilities
          ? "Nearest Facilities" 
          : _isFirstLoad 
            ? "Home" 
            : pageTitles[_currentIndex],

            style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        
        ),
        //Back Button only if not on Home
        leading: (_isFirstLoad && !_showNearestFacilities) 
          ? null 
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: "Home",
              onPressed: () {
                setState(() {
                if (_showNearestFacilities) {
                  _showNearestFacilities = false;
                  _isFirstLoad = true;
                } else {
                  _isFirstLoad = true;
                }
                });
              },
            ),
      ),
      body: Center(
        child: bodyContent,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.call),
        onPressed: () {
          //Should redirect to Add Routine/Task
          print("Emergency Call");
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
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
            label: "FAQs",
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTap, //Passing on Tap
      ),
    );
  }
}
