
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints_project/Widgets/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';

import '../main.dart';
import 'login_screen.dart';



class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  var id = sharedPreferences!.getInt('userID');
  String? email= sharedPreferences!.getString('email');

  Container slideContiner(IconData icon, Color color, String txt) {
    return Container(
      height: 90,
      margin: EdgeInsets.only(right: 5),
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          Text(
            txt,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
  void _showErrorSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          SizedBox(width: 16),
          Expanded(
            child: Text(
              "Notification has been deleted",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black45,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorForDesign().lightblue,
        body: id == null ?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("You must login first",style: TextStyle(color: Colors.black45),),
              const SizedBox(height: 10,),
              InkWell(
                  onTap: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                    );
                  },
                  child: const Text("LOGIN",style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline),)
              ),

            ],
          ),
        ) :
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('notifications').where('reciveremail',isEqualTo: email).where('status',isEqualTo: 1).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                ),
              );
            }else{
              final docs = snapshot.data!.docs;
              if(docs.isEmpty){
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("You don't have any notifications",style: TextStyle(color: Colors.black45),),
                    ],
                  ),
                );
              }else{
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, int index) {

                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      secondaryActions: <Widget>[
                        InkWell(
                          onTap: () {
                            CollectionReference userRef = FirebaseFirestore.instance.collection('notifications');
                            userRef.doc(docs[index].id).update({
                              "status" : 0,
                            }).then((value) {
                              _showErrorSnackBar(context);
                            }).catchError((e){
                              print("Error is $e");
                            });
                          },
                          child: slideContiner(
                              Icons.delete, Colors.red, "Delete"),
                        )
                      ],
                      child: Container(
                          margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                          decoration: BoxDecoration(
                              color: ColorForDesign().blue,
                              borderRadius: BorderRadiusDirectional.circular(8)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(docs[index]['image']),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  docs[index]['title'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  docs[index]['body'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                            onTap: () {

                            },
                          )),
                    );
                  },
                );
              }
            }
          },
        )
    );
  }
}
