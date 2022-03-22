import 'dart:convert';

import 'package:complaints_project/Model/user_info.dart';
import 'package:complaints_project/Screens/profile_screen.dart';
import 'package:complaints_project/Widgets/colors.dart';
import 'package:complaints_project/Widgets/drawer.dart';
import 'package:complaints_project/Widgets/drawer_without_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'add_post_screen.dart';
import 'home_page.dart';
import 'notifications_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  var id = sharedPreferences!.getInt('userID');
  String title = "onTheGo";

  int _currentIndex = 0;

  List<UserInfoApi> user = [];
  Future UserInfo() async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/UserInfo.php?userid=${id.toString()}';
    final response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final List<UserInfoApi> userlist = userInfoApiFromJson(response.body);
      return userlist;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserInfo().then((userlist){
      setState(() {
        user = userlist;
      });
    });
  }
  void _showErrorSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(Icons.error_outline, size: 20,color: Colors.black,),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              "You must login in before",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



  @override
  Widget build(BuildContext context) {
    void appTitle(){
      switch(_currentIndex) {
        case 0: {
          title = "onTheGo";
        }
        break;
        case 1: {
          title = "Edit Profile" ;
        }
        break;
        case 2: {
          title = "Notifications" ;
        }
        break;
        case 3: {
          title = "Add Post" ;
        }
        break;
        default: {
          title = "onTheGo";
        }
        break;
      }
    }
    final List<Widget> _pages = <Widget>[
      HomePage(),
      ProfileScreen(user: user,show: false),
      Notifications(),
      AddPost(user: user,show: false),
    ];
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    void _onItemTapped(int index) {
      setState(() {
        _currentIndex = index;
        appTitle();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: ColorForDesign().white, fontSize: 25),),
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
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'Notification',
            icon: Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            label: 'Add Post',
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: id == null ? const DrawerWithoutUser() :NavDrawer(user: user,),
      body: Center(
        child: _pages.elementAt(_currentIndex),
      )
    );
  }
}
