import 'dart:async';

import 'package:complaints_project/Screens/profile_screen.dart';
import 'package:complaints_project/Widgets/colors.dart';
import 'package:complaints_project/Widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
            itemCount: 3,
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
                            FlatButton(
                              onPressed: () {
                                // Perform some action
                              },
                              child: const Text('ACTION 1'),
                            ),
                            FlatButton(
                              onPressed: () {
                                // Perform some action
                              },
                              child: const Text('ACTION 2'),
                            ),
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
