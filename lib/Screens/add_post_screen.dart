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

import '../main.dart';
import 'login_screen.dart';

class AddPost extends StatefulWidget {
  List<UserInfoApi>? user;
  AddPost({Key? key,this.user}) : super(key: key);

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

  Future insertPost(var user_id,var title ,var description,var image,var staus,var type) async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/insertPost.php';
    final response = await http.post(Uri.parse(url), body: {
      "user_id": user_id,
      "title": title,
      "description": description,
      "image": image,
      "staus" : staus,
      "type" : type
    });
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
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

        }
        },
        label: const Text('Upload Post'),
        icon: const Icon(Icons.post_add),
        backgroundColor: ColorForDesign().blue,
      ),
      backgroundColor: ColorForDesign().lightblue,
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
                Padding(padding: const EdgeInsets.fromLTRB(30, 20, 20, 0),
                  child: Text("Add post here",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorForDesign().blue,
                        fontSize: 20
                    ),
                  ),
                ),
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
                // Builder(
                //   builder: (context) => Center(
                //     child: ButtonWidget(
                //       text: 'Upload Post',
                //       width: 300,
                //       onClicked: () async {
                //
                //       },
                //     ),
                //   ),
                // ),
              ],
            );

          }
        },
      ),
    );
  }
}
