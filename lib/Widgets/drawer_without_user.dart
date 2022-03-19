import 'package:complaints_project/Model/user_info.dart';
import 'package:complaints_project/Screens/login_screen.dart';
import 'package:complaints_project/Screens/my_posts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'colors.dart';

class DrawerWithoutUser extends StatefulWidget {
  const DrawerWithoutUser({Key? key}) : super(key: key);

  @override
  _DrawerWithoutUserState createState() => _DrawerWithoutUserState();
}

class _DrawerWithoutUserState extends State<DrawerWithoutUser> {
  var id = sharedPreferences!.getInt('userID');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Drawer(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child:  Column(
              children: [
                InkWell(
                    onTap: () async {

                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30),
                      decoration: BoxDecoration(
                        color: ColorForDesign().blue,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(left: 10,),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context)=>LoginScreen(),
                                          )
                                      );
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Login',
                                        style: TextStyle(
                                          color: ColorForDesign().white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    )
                ),
                // ListTile(
                //     title: const Text('My Posts',style: TextStyle(),),
                //     leading: Icon(Icons.assignment),
                //     trailing: Icon(Icons.arrow_right),
                //     onTap: (){
                //       Navigator.of(context).push(MaterialPageRoute(
                //           builder: (BuildContext context) => MyPosts())
                //       );
                //     }
                // ),
                ListTile(title: const Text('Login',style: TextStyle(),),
                    leading: Icon(Icons.login),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () async {

                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                      );
                    }),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
