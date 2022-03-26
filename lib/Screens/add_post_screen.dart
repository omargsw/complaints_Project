import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints_project/Model/firebase_api.dart';
import 'package:complaints_project/Model/user_info.dart';
import 'package:complaints_project/Widgets/actionbattons.dart';
import 'package:complaints_project/Widgets/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import '../Widgets/appbar.dart';
import '../main.dart';
import 'login_screen.dart';

class AddPost extends StatefulWidget {
  final List<UserInfoApi>? user;
  bool show;
  AddPost({Key? key,this.user,required this.show}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  var id = sharedPreferences!.getInt('userID');

  var name ;
  var email ;
  var status ;
  GlobalKey<FormState> _form= GlobalKey<FormState>();
  var desc=TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? file;
  List<File>? files;
  String path = '';
  UploadTask? task;
  bool uplfile = false;
  String? urlDownload;
  File ? imageFile;
  final imagePicker = ImagePicker();

  Future insertPost(var user_id,var title ,var description,var image,var status,var type) async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/insertPost.php';
    final response = await http.post(Uri.parse(url), body: {
      "user_id": user_id,
      "title": title,
      "description": description,
      "image": image,
      "status" : status,
      "type" : type
    });
    print(response.body);
  }

  void _showDoneSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(Icons.done_outline, size: 20,color: Colors.green,),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              "Post Uploaded",
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
      floatingActionButton: id == null ?
          Container() :
      FloatingActionButton.extended(
        onPressed: () async {
          if(_form.currentState!.validate()){
            if (file == null) return;
            final fileName = basename(file!.path);
            final destination = 'files/$fileName';

            task = FirebaseApi.uploadFile(destination, file!);
            setState(() {});

            if (task == null) return;

            final snapshot = await task!.whenComplete(() {});
            urlDownload = await snapshot.ref.getDownloadURL();

            path = base64Encode(file!.readAsBytesSync());

            await insertPost(id.toString(), "", desc.text.toString(), urlDownload.toString(), "Pending",status);

          Map<String, dynamic> post = {
          "name": name,
          "email": email,
          "userid": id,
          "description" : desc.text,
          "fileurl" : urlDownload,
          "status" : status,
          "time": FieldValue.serverTimestamp(),
          };
          desc.clear();
          await _firestore.collection('posts').doc(email).collection('posts').add(post);
            _showDoneSnackBar(context);

          }
        },
        label: const Text('Upload Post'),
        icon: const Icon(Icons.post_add),
        backgroundColor: ColorForDesign().blue,
      ),
      backgroundColor: ColorForDesign().lightblue,
      appBar: AppAppBar(title: "Notifications",show: widget.show),
      body: widget.user!.isEmpty || widget.user == null ?
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
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.user!.length,
        itemBuilder: (context, index) {
          UserInfoApi userApi = widget.user![index];
          name = userApi.name;
          email = userApi.email;
          if(widget.user!.isEmpty || widget.user == null){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
              ],
            );
          }else{
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _form,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      maxLines: 5,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        hintText: 'Description',
                        hintStyle: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty) {
                          return "Required";
                        }
                      },
                      controller: desc,
                    ),
                  ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['mp4'],
                            allowMultiple: false);

                        if (result == null) return;
                        final path = result.files.single.path!;
                        files = result.paths.map((path) => File(path!)).toList();
                        // print(path);
                        setState(() {
                          file = File(path);
                          status = "video";
                          //uplfile = true;
                        });
                      },
                      icon: Icon(Icons.videocam, size: 18),
                      label: Text("Video"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['png','jpg'],
                            allowMultiple: false);

                        if (result == null) return;
                        final path = result.files.single.path!;
                        files = result.paths.map((path) => File(path!)).toList();
                        print("Path is ===="+path);
                        setState(() {
                          file = File(path);
                          status = "image";
                          //uplfile = true;
                        });
                      },
                      icon: Icon(Icons.image, size: 18),
                      label: Text("Image"),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                task != null ? Center(
                  child: buildUploadStatus(task!),
                ) :
                Container(),
              ],
            );

          }
        },
      ),
    );
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );

}
