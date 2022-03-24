import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints_project/Model/fetch_commentApi.dart';
import 'package:complaints_project/Widgets/colors.dart';
import 'package:complaints_project/Widgets/video_player.dart';
import 'package:complaints_project/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../Model/fetch_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var id = sharedPreferences!.getInt('userID');
  var typeid = sharedPreferences!.getInt('user_type_id');
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var fbm = FirebaseMessaging.instance;
  var title;
  var body;

  GlobalKey<FormState> _form= GlobalKey<FormState>();
  var comment = TextEditingController();

  List<PostApi> posts = [];
  Future Posts() async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/fetchPost.php';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<PostApi> postlist = postApiFromJson(response.body);
      return postlist;
    }
  }

  List<CommentApi> commentlist = [];
  Future Comment(var postid) async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/fetchComment.php?post_id=$postid';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<CommentApi> commentjson = commentApiFromJson(response.body);
      return commentjson;
    }
  }

  Future insertComment(var post_id,var user_id ,var description) async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/insertcomment.php';
    final response = await http.post(Uri.parse(url), body: {
      "post_id": post_id,
      "user_id": user_id,
      "description": description,
    });
    print(response.body);
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
              "You must login first",
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

  List userinfo = [];
  Future UserInfo() async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/UserInfo.php?userid=${id.toString()}';
    var response = await http.get(Uri.parse(url));
    var responsebody = jsonDecode(response.body);
    for(int i = 0 ; i < responsebody.length; i++){
      userinfo.add(responsebody[i]);
    }
    print(userinfo);
  }


  Widget bottomSheet(var post_id,var user_id,var email) {
    return Container(
      height: 400.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 65),
            child: ListView.builder(
              itemCount: commentlist.length,
              itemBuilder: (context, index) {
                CommentApi commentApi = commentlist[index];
                if(commentlist.isEmpty || commentlist == null){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                    ],
                  );
                }else{
                  return  Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        leading: CircleAvatar(
                          radius: 23,
                          backgroundImage: NetworkImage('https://abulsamrie11.000webhostapp.com/image/'+commentApi.image)
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              commentApi.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                              fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              commentApi.description,
                              style: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                          });
                        },
                      ),
                      const Divider(
                        height: 20,
                        thickness: 0,
                        indent: 40,
                        endIndent: 40,
                        color: Colors.black,
                      ),
                    ],
                  );
                }
              },),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: ColorForDesign().blue,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Form(
                    key: _form,
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          hintText: "comment",
                          hintStyle: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.mode_comment_outlined,color: ColorForDesign().blue,),
                        ),
                        validator: (value){
                          if(value!.isEmpty) {
                            return "Required";
                          }
                        },
                        controller: comment,
                      ),
                    ),),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10),)
                    ),
                    child: IconButton(onPressed: () async {
                      if (id == null){
                        Navigator.of(context).pop();
                        _showErrorSnackBar(context);
                      }else{
                        title = "${userinfo[0]['name']} added comment";
                        body = comment.text;
                        await insertComment(post_id.toString(), id.toString(), comment.text);
                        setState(() {
                          Comment(post_id).then((commentjson){
                            setState(() {
                              commentlist = commentjson;
                            });
                          });
                        });
                        await _firestore.collection('notifications').doc().set({
                          "name": userinfo[0]['name'],
                          "email": userinfo[0]['email'],
                          "image" : "https://abulsamrie11.000webhostapp.com/image/"+userinfo[0]['image'],
                          "userid": id,
                          "title" : title,
                          "body" : body,
                          "status": 1,
                          "reciveremail" : email,
                          "time": FieldValue.serverTimestamp(),
                        });
                        sendNotify(1, title, body, id);
                        comment.clear();
                      }
                    }, icon: Icon(Icons.send,color: ColorForDesign().blue,)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  var serverToken = "AAAADMhHdhQ:APA91bHBPPBkU6pleXgUu4b0S6_s-uNkrlPlgEzc9MrslbFo55RSoK"
      "qVJeL7pjdR2g4r4KYrom-V4VxanIkAri89GIc7P4Ey5rW4ghUPXKmvBms5C8pomYCmrm0PybUafUrmJJkoB4IO";

  sendNotify(int id , String title,String body,var userid) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body.toString(),
            'title': title.toString(),
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': id,
            'status': 'done'
          },
          //الى من رح توصل الرساله

          'to': '/topics/$userid'
        },
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    Posts().then((postlist){
      setState(() {
        posts = postlist;
      });
    });
    UserInfo();
    //from firebase**********************************
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: "@mipmap/ic_launcher",
              ),
            ));
      }
      // print(notification!.title);
      // print(notification.body);
    });
    //when i click notify **************************************************
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body.toString())],
                  ),
                ),
              );
            });
      }
    });

    // FirebaseMessaging.instance.subscribeToTopic('$id');
    // fbm.getToken().then((value) {
    //   print("-----------------------------");
    //   print(value);
    //   print("-----------------------------");
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorForDesign().lightblue,
      body: Container(
          decoration: BoxDecoration(
              color: ColorForDesign().lightblue,
          ),
          child: posts.isEmpty || posts == null ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Container(child: const CircularProgressIndicator())),
            ],
          ) :
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              PostApi postApi = posts[index];
              if(posts.isEmpty || posts == null){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                  ],
                );
              }else{
                return Column(
                  children: <Widget>[
                    Card(
                      color: Colors.white,
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage('https://abulsamrie11.000webhostapp.com/image/${postApi.userImage}')
                            ),
                            title: Text(postApi.name),
                            subtitle: Text("${postApi.createdAt.day}/${postApi.createdAt.month}/${postApi.createdAt.year}",
                              style: TextStyle(color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(postApi.description,
                              style: TextStyle(color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          VideoPlayerWidget(url: postApi.image,type: postApi.type,),
                          userinfo[0]['user_type_id'] == 1 ?
                          ButtonBar(
                            alignment: MainAxisAlignment.start,
                            children: [
                              TextButton.icon(
                                onPressed: () async {
                                    await Comment(postApi.id).then((commentjson){
                                      setState(() {
                                        commentlist = commentjson;
                                      });
                                    });
                                  showModalBottomSheet(
                                    context: context,
                                    builder: ((builder){
                                      return StatefulBuilder(builder: (context, setState) => bottomSheet(postApi.id,id,postApi.email),);
                                    }
                                  ));
                                },
                                label: const Text("Add Comment",style: TextStyle(color: Colors.green),),
                                icon: const Icon(Icons.mode_comment_outlined, size: 18,color: Colors.green,),
                              ),
                            ],
                          ) :
                          ButtonBar(
                            alignment: MainAxisAlignment.start,
                            children: [
                              TextButton.icon(
                                onPressed: () async {
                                  await Comment(postApi.id).then((commentjson){
                                    setState(() {
                                      commentlist = commentjson;
                                    });
                                  });
                                  showModalBottomSheet(
                                      context: context,
                                      builder: ((builder){
                                        return StatefulBuilder(builder: (context, setState) => bottomSheet(postApi.id,id,postApi.email),);
                                      }
                                      ));
                                },
                                label: const Text("Add Comment",style: TextStyle(color: Colors.green),),
                                icon: const Icon(Icons.mode_comment_outlined, size: 18,color: Colors.green,),
                              ),
                              TextButton.icon(
                                onPressed: () async {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          backgroundColor: Colors.white,
                                          content: Text("Are you sure to accept this post ?",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: ColorForDesign().blue,
                                              )),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('NO',
                                                  style: TextStyle(
                                                    color: ColorForDesign().blue,
                                                  )),
                                            ),
                                            TextButton(
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('YES',
                                                  style: TextStyle(
                                                    color: ColorForDesign().blue,
                                                  )),
                                            ),

                                          ],
                                        );
                                      });
                                },
                                label: Text("Accept ",style: TextStyle(color: ColorForDesign().blue),),
                                icon: Icon(Icons.access_time, size: 18,color: ColorForDesign().blue,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),


                  ],
                );
              }

            },
          )

      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }
}
