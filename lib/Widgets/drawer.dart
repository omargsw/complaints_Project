import 'package:complaints_project/Screens/login_screen.dart';
import 'package:complaints_project/Screens/my_posts.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'colors.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                child: InkWell(
                  onTap: (){
                    // Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //       builder: (context)=>ProfileScreen(),
                    //     )
                    // );
                  },
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: ColorForDesign().blue,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    accountName: Text("Name"),
                    accountEmail: Text("Email"),
                    currentAccountPicture: ClipOval(
                      child: Image.asset('assets/images/image.jpg',
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                  title: const Text('My Posts',style: TextStyle(),),
                  leading: Icon(Icons.assignment),
                  trailing: Icon(Icons.arrow_right),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MyPosts())
                    );
                  }
              ),
              ListTile(title: const Text('Logout',style: TextStyle(),),
                  leading: Icon(Icons.logout),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () async {
                    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    // sharedPreferences.clear();
                    // await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                            (Route<dynamic> route) => false);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}




//NavDrawer