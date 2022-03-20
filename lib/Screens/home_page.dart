import 'dart:async';
import 'dart:convert';

import 'package:complaints_project/Widgets/colors.dart';
import 'package:complaints_project/Widgets/video_player.dart';
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

  VideoPlayerController? _controller;
  bool isplay = true;

  List<PostApi> posts = [];
  Future Posts() async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/fetchPost.php';
    final response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final List<PostApi> postlist = postApiFromJson(response.body);
      return postlist;
    }
  }

  void startTimer() {
    Timer(
        Duration(seconds: 2), (){
          setState(() {
            isplay = false;
          });

            });
  }

  @override
  void initState() {
    super.initState();
    Posts().then((postlist){
      setState(() {
        posts = postlist;
      });
    });
    // _controller = VideoPlayerController.network(
    //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
  }
  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller!.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorForDesign().lightblue,
      body: Container(
          decoration: BoxDecoration(
              color: ColorForDesign().lightblue,
          ),
          child: ListView.builder(
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
                                onPressed: () {
                                  // Respond to button press
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
