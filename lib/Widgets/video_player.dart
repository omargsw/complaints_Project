import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  var url;
  var type;
  VideoPlayerWidget({Key? key,this.url,this.type}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
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
        widget.url)
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
    return Container(
      width: MediaQuery.of(context).size.width,
      child: widget.type == "video" ?
      Center(
        child: _controller!.value.isInitialized
            ? Stack(
          alignment: Alignment.center,
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
            Center(
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
            ) : Container(),

          ],
        )
            : Container(),
      ) :
      Image.network('${widget.url}'),
    );
  }
}
