import 'package:complaints_project/Model/user_info.dart';
import 'package:complaints_project/Screens/accepted_post.dart';
import 'package:complaints_project/Screens/login_screen.dart';
import 'package:complaints_project/Screens/my_posts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/add_post_screen.dart';
import '../Screens/profile_screen.dart';
import '../main.dart';
import 'colors.dart';

class NavDrawer extends StatefulWidget {
  final List<UserInfoApi>? user;
  const NavDrawer({Key? key,this.user}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  var id = sharedPreferences!.getInt('userID');
  int? typeid = sharedPreferences!.getInt('typeID');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: typeid == 1 ?
        Drawer(
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
                    InkWell(
                      onTap: (){

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
                    ListTile(
                        title: const Text('My Posts',style: TextStyle(),),
                        leading: Icon(Icons.assignment_outlined,color: ColorForDesign().blue,),
                        trailing: const Icon(Icons.arrow_right),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => MyPosts())
                          );
                        }
                    ),
                    ListTile(
                        title: const Text('Add Posts',style: TextStyle(),),
                        leading: Icon(Icons.post_add,color: ColorForDesign().blue,),
                        trailing: const Icon(Icons.arrow_right),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => AddPost(user: widget.user,show: true,))
                          );
                        }
                    ),
                    ListTile(
                        title: const Text('Account Setting',style: TextStyle(),),
                        leading: Icon(Icons.person_outline,color: ColorForDesign().blue,),
                        trailing: const Icon(Icons.arrow_right),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => ProfileScreen(user: widget.user,show: true,))
                          );
                        }
                    ),
                    ListTile(title: const Text('Logout',style: TextStyle(),),
                        leading: Icon(Icons.logout,color: ColorForDesign().blue,),
                        trailing: const Icon(Icons.arrow_right),
                        onTap: () async {
                          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                          sharedPreferences.clear();
                          // await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
                                  (Route<dynamic> route) => false);
                        }),
                  ],
                );
              }
            },

          ),
        ) :
        Drawer(
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
                    InkWell(
                      onTap: (){

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
                    ListTile(
                        title: const Text("Post Accepted",style: TextStyle(),),
                        leading: Icon(Icons.access_time,color: ColorForDesign().blue,),
                        trailing: const Icon(Icons.arrow_right),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => const AcceptedPost())
                          );
                        }
                    ),
                    ListTile(
                        title: const Text('Account Setting',style: TextStyle(),),
                        leading: Icon(Icons.person_outline,color: ColorForDesign().blue,),
                        trailing: const Icon(Icons.arrow_right),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => ProfileScreen(user: widget.user,show: true,))
                          );
                        }
                    ),
                    ListTile(title: const Text('Logout',style: TextStyle(),),
                        leading: Icon(Icons.logout,color: ColorForDesign().blue,),
                        trailing: const Icon(Icons.arrow_right),
                        onTap: () async {
                          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                          sharedPreferences.clear();
                          // await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
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