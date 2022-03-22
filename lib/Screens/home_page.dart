import 'dart:async';
import 'dart:convert';

import 'package:complaints_project/Model/fetch_commentApi.dart';
import 'package:complaints_project/Widgets/colors.dart';
import 'package:complaints_project/Widgets/video_player.dart';
import 'package:complaints_project/main.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import '../Model/fetch_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var id = sharedPreferences!.getInt('userID');

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


  Widget bottomSheet(var post_id,var user_id) {
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
                      await insertComment(post_id.toString(), id.toString(), comment.text);
                      setState(() {
                        Comment(post_id).then((commentjson){
                          setState(() {
                            commentlist = commentjson;
                          });
                        });
                      });
                      comment.clear();
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


  @override
  void initState() {
    super.initState();
    Posts().then((postlist){
      setState(() {
        posts = postlist;
      });
    });
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
                                      return StatefulBuilder(builder: (context, setState) => bottomSheet(postApi.id,id),);
                                    }
                                  ));
                                },
                                label: const Text("Add Comment",style: TextStyle(color: Colors.green),),
                                icon: Icon(Icons.mode_comment_outlined, size: 18,color: Colors.green,),
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
}
