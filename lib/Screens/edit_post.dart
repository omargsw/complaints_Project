import 'dart:convert';
import 'dart:io';

import 'package:complaints_project/Widgets/actionbattons.dart';
import 'package:complaints_project/Widgets/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../Model/firebase_api.dart';

class EditPost extends StatefulWidget {
  var postID;
  EditPost({Key? key,this.postID}) : super(key: key);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  GlobalKey<FormState> _form= GlobalKey<FormState>();
  var desc=TextEditingController();
  var status ;
  File? file;
  List<File>? files;
  String path = '';
  UploadTask? task;
  bool uplfile = false;
  String? urlDownload;
  File ? imageFile;
  final imagePicker = ImagePicker();

  Future updateDescription(int id, var desc) async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/updateDesc.php';
    final response = await http.post(Uri.parse(url),
        body: {"id": id.toString(), "description": desc});
    print('UPDATE-Desc------>' + response.body);
  }
  Future updateImage(int id, var img) async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/updateImagePost.php';
    final response = await http.post(Uri.parse(url),
        body: {"id": id.toString(), "image": img});
    print('UPDATE-Image OR video------>' + response.body);
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
              "Post Updated",
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
  void _showErrorSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(Icons.error_outline, size: 20,color: Colors.black,),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              "You must update description or image/video",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorForDesign().lightblue,
      appBar: AppBar(
        title: Text("Edit Post", style: TextStyle(color: ColorForDesign().white,),),
        centerTitle: true,
        backgroundColor: ColorForDesign().blue,
      ),
      bottomNavigationBar: Container(
        height: 80,
        child: Builder(
          builder: (context) => Center(
            child: ButtonWidget(
              text: 'SAVE',
              width: 300,
              onClicked: () async {
                if(desc.text.isNotEmpty){
                  if (file == null){
                    await updateDescription(widget.postID, desc.text);
                    desc.clear();
                    _showDoneSnackBar(context);
                    Navigator.pop(context, true);
                  } else{
                    final fileName = basename(file!.path);
                    final destination = 'files/$fileName';

                    task = FirebaseApi.uploadFile(destination, file!);
                    setState(() {});

                    if (task == null) {
                      print("Task is Empty");
                    }else{
                      final snapshot = await task!.whenComplete(() {});
                      urlDownload = await snapshot.ref.getDownloadURL();
                    }
                    await updateDescription(widget.postID, desc.text);
                    await updateImage(widget.postID, urlDownload);
                    desc.clear();
                    _showDoneSnackBar(context);
                    Navigator.pop(context, true);
                  }
                }else{
                  if (file == null){
                    _showErrorSnackBar(context);
                  } else{
                    final fileName = basename(file!.path);
                    final destination = 'files/$fileName';

                    task = FirebaseApi.uploadFile(destination, file!);
                    setState(() {});

                    if (task == null) {
                      print("Task is Empty");
                    }else{
                      final snapshot = await task!.whenComplete(() {});
                      urlDownload = await snapshot.ref.getDownloadURL();
                    }
                    await updateImage(widget.postID, urlDownload);
                    _showDoneSnackBar(context);
                    Navigator.pop(context, true);
                  }
                }
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                controller: desc,
              ),
            ),
            const SizedBox(height: 10,),
            const Center(
                child: Text("To edit a photo or video",style: TextStyle(fontWeight: FontWeight.bold),)),
            const SizedBox(height: 10,),
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
                      status = "Video";
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
                    setState(() {
                      file = File(path);
                      status = "Image";
                      //uplfile = true;
                    });
                  },
                  icon: Icon(Icons.image, size: 18),
                  label: Text("Image"),
                )
              ],
            ),
            const SizedBox(height: 20,),
            file != null ?
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.green,
                          width: 2.0,
                          style: BorderStyle.solid),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.done_outline,color: Colors.green,size: 60,),
                        const SizedBox(height: 20,),
                        Text("$status is uploaded"),
                      ],
                    ),
                  ),
                ),
              ),
            ) : Container(),


          ],
        ),
      ),
    );
  }
}
