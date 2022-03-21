import 'dart:async';

import 'package:complaints_project/Widgets/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import '../Model/mypostApi.dart';
import '../Widgets/video_player.dart';
import 'edit_post.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({Key? key}) : super(key: key);

  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {

  List<MyPostApi> myposts = [];
  Future MyPosts() async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/fetchPost.php';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<MyPostApi> postlist = myPostApiFromJson(response.body);
      return postlist;
    }
  }
  Future RemoveProducts(var id) async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/removePost.php';
    final response = await http.post(Uri.parse(url),
        body: {"id": id.toString(),}
    );
    print(response.body);
  }

  void _showErrorDialog(int postId) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.white,
            content: Text("Are you sure to delete this post ?",
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
                  RemoveProducts(postId);
                  setState(() {
                    MyPosts().then((postlist){
                      setState(() {
                        myposts = postlist;
                      });
                    });
                  });
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
  }

  @override
  void initState() {
    super.initState();
    MyPosts().then((postlist){
      setState(() {
        myposts = postlist;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorForDesign().lightblue,
      appBar: AppBar(
        title: Text("My Posts", style: TextStyle(color: ColorForDesign().white,),),
        centerTitle: true,
        backgroundColor: ColorForDesign().blue,
      ),
      body: Container(
          decoration: BoxDecoration(
            color: ColorForDesign().lightblue,
          ),
          child: myposts.isEmpty || myposts == null ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Container(child: const CircularProgressIndicator())),
            ],
          ) :
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: myposts.length,
            itemBuilder: (context, index) {
              MyPostApi postApi = myposts[index];
              if(myposts.isEmpty || myposts == null){
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
                          ButtonBar(
                            alignment: MainAxisAlignment.start,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditPost(postID: postApi.id,)),
                                  ).then((value) {
                                    setState(() {
                                      if (value == true) {
                                        MyPosts().then((postlist){
                                          setState(() {
                                            myposts = postlist;
                                          });
                                        });
                                      } else {
                                        null;
                                      }
                                    });
                                  });
                                },
                                icon: const Icon(Icons.edit, size: 18,color: Colors.green,),
                                label: const Text("Edit",style: TextStyle(color: Colors.green),),
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  _showErrorDialog(postApi.id);
                                },
                                icon: const Icon(Icons.delete, size: 18,color: Colors.red,),
                                label: const Text("Delete",style: TextStyle(color: Colors.red),),
                              )
                            ],
                          ),
                          VideoPlayerWidget(url: postApi.image,type: postApi.type,),
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
}
