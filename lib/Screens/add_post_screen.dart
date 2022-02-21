import 'package:complaints_project/Widgets/actionbattons.dart';
import 'package:complaints_project/Widgets/colors.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  GlobalKey<FormState> _form= GlobalKey<FormState>();
  var desc=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorForDesign().lightblue,
      body: Column(
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
                  contentPadding: const EdgeInsets.all(0),
                  hintText: '   Description',
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
                onPressed: () {
                  // Respond to button press
                },
                icon: Icon(Icons.videocam, size: 18),
                label: Text("Video"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Respond to button press
                },
                icon: Icon(Icons.image, size: 18),
                label: Text("Image"),
              )
            ],
          ),
          Spacer(),
          Builder(
            builder: (context) => Center(
              child: ButtonWidget(
                text: 'Post',
                width: 150,
                onClicked: () async {

                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
