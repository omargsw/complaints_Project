import 'package:complaints_project/Model/user_info.dart';
import 'package:complaints_project/Screens/login_screen.dart';
import 'package:complaints_project/Screens/my_posts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'colors.dart';

class NavDrawer extends StatefulWidget {
  List<UserInfoApi>? user;
  NavDrawer({Key? key,this.user}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  var id = sharedPreferences!.getInt('userID');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Drawer(
          child: ListView.builder(
            itemCount: widget.user!.length,
            itemBuilder: (context, index) {
              UserInfoApi userApi = widget.user![index];
              if(widget.user!.isEmpty || widget.user == null){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                  ],
                );
              }else{
                return Column(
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
                          accountName: Text(userApi.name),
                          accountEmail: Text(userApi.email),
                          currentAccountPicture: ClipOval(
                            child: Image.network('https://abulsamrie11.000webhostapp.com/image/${userApi.image}',
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
                          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                          sharedPreferences.clear();
                          // await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                                  (Route<dynamic> route) => false);
                        }),
                  ],
                );
              }
            },

          ),
        ),
      ),
    );
  }
}




//NavDrawer