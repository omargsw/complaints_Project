import 'dart:async';

import 'package:complaints_project/Widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'edit_post.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({Key? key}) : super(key: key);

  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  VideoPlayerController? _controller;
  bool isplay = true;

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
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }
  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  void _showErrorDialog() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: ColorForDesign().white,
            content: Text("Are you sure to delete this post ?",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: ColorForDesign().blue,
                )),
            actions: <Widget>[
              Row(
                children: [
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text('No',
                        style: TextStyle(
                          color: ColorForDesign().blue,
                        )),
                  ),
                  TextButton(
                    onPressed: (){

                    },
                    child: Text('Yes',
                        style: TextStyle(
                          color: ColorForDesign().blue,
                        )),
                  ),
                ],
              ),
            ],
          );
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
              borderRadius: BorderRadius.only(topLeft: const Radius.circular(0), topRight: Radius.circular(40))

          ),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 1,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage('assets/images/image.jpg'),
                          ),
                          title: const Text('name'),
                          subtitle: Text(
                            '19/2/2022',
                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.start,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) => EditPost())
                                );
                              },
                              icon: const Icon(Icons.edit, size: 18,color: Colors.green,),
                              label: const Text("Edit",style: TextStyle(color: Colors.green),),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                _showErrorDialog();
                              },
                              icon: const Icon(Icons.delete, size: 18,color: Colors.red,),
                              label: const Text("Delete",style: TextStyle(color: Colors.red),),
                            )
                          ],
                        ),
                        Center(
                          child: _controller!.value.isInitialized
                              ? Stack(
                            children: [
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    if(isplay){
                                      isplay = false;
                                    }else{
                                      isplay = true;
                                    }
                                  });
                                },
                                child: AspectRatio(
                                  aspectRatio: _controller!.value.aspectRatio,
                                  child: VideoPlayer(_controller!),
                                ),
                              ),
                              isplay ?
                              Positioned(
                                  top: 70,
                                  left: 150,
                                  child: Center(
                                    child: FloatingActionButton(
                                      backgroundColor: Colors.black54,
                                      onPressed: () {
                                        startTimer();
                                        setState(() {
                                          _controller!.value.isPlaying
                                              ? _controller!.pause()
                                              : _controller!.play();
                                        });
                                      },
                                      child: Icon(
                                        _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                        size: 40,
                                      ),
                                    ),
                                  )
                              ) : Container(),

                            ],
                          )
                              : Container(),
                        ),
                      ],
                    ),
                  ),


                ],
              );

            },
          )

      ),
    );
  }
}
