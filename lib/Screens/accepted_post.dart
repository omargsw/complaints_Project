import 'dart:async';
import 'package:complaints_project/Widgets/colors.dart';
import 'package:complaints_project/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/acceptedApi.dart';
import '../Model/mypostApi.dart';
import '../Widgets/appbar.dart';
import '../Widgets/video_player.dart';
import 'edit_post.dart';

class AcceptedPost extends StatefulWidget {
  const AcceptedPost({Key? key}) : super(key: key);

  @override
  _AcceptedPostState createState() => _AcceptedPostState();
}

class _AcceptedPostState extends State<AcceptedPost> {
  var id = sharedPreferences!.getInt('userID');
  bool isloading = true;

  List<AcceptedApi> myposts = [];
  Future AcceptedPosts() async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/fetchPostAccepted.php?accepted_id=${id.toString()}&active=2';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<AcceptedApi> postlist = acceptedApiFromJson(response.body);
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

  void _showErrorSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(Icons.error_outline, size: 20,color: Colors.black,),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              "The post has been deleted",
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
                    AcceptedPosts().then((postlist){
                      setState(() {
                        myposts = postlist;
                      });
                    });
                  });
                  _showErrorSnackBar(context);
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
    AcceptedPosts().then((postlist){
      setState(() {
        myposts = postlist;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorForDesign().lightblue,
      appBar: AppAppBar(title: "Post Accepted",show: true),
      body: Container(
          decoration: BoxDecoration(
            color: ColorForDesign().lightblue,
          ),
          child: myposts.isEmpty || myposts==null ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Container(child: const Text("You don't have any posts",style: TextStyle(color: Colors.black45),))),
            ],
          ) :
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: myposts.length,
            itemBuilder: (context, index) {
              AcceptedApi postApi = myposts[index];
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
                      child: Stack(
                        children: [
                          Column(
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
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(postApi.status,style: TextStyle(color: ColorForDesign().blue),),
                            ),
                          )
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
