import 'package:complaints_project/Screens/profile_screen.dart';
import 'package:complaints_project/Widgets/colors.dart';
import 'package:complaints_project/Widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'add_post_screen.dart';
import 'home_page.dart';
import 'notifications_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  int _currentIndex = 0;
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    ProfileScreen(),
    Notifications(),
    AddPost(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    void _onItemTapped(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("App title", style: TextStyle(color: ColorForDesign().white, fontSize: 30),),
        centerTitle: true,
        backgroundColor: ColorForDesign().blue,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.surface,
        selectedItemColor: ColorForDesign().blue,
        unselectedItemColor: colorScheme.onSurface.withOpacity(.30),
        selectedLabelStyle: textTheme.caption,
        unselectedLabelStyle: textTheme.caption,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text('Profile'),
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            title: Text('Notification'),
            icon: Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            title: Text('Add Post'),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: const NavDrawer(),
      body: Center(
        child: _pages.elementAt(_currentIndex),
      )
    );
  }
}
