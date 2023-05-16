import 'package:meditracker/main.dart';
import 'package:meditracker/page/calendar.dart';
import 'package:meditracker/page/notifications.dart';
import 'package:meditracker/page/mymedicines.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_swipeable_pages_withbottomNavBar/page/notifications.dart';
import 'package:meditracker/globals.dart' as globals;

class Main2Page extends StatefulWidget {
  const Main2Page({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Main2PageState();
}

class _Main2PageState extends State<Main2Page> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final screens = [
    NotificationsPage(),
    MyMedicinesPage(),
    CalendarPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: IndexedStack(
      //index: currentIndex,
      //children: screens,
      //),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTappedBar,
        currentIndex: _selectedIndex,
        backgroundColor: Colors.indigo[200],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_important),
            label: 'Notifications',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'MyMedicines',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
            backgroundColor: Colors.white,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: screens,
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }
}