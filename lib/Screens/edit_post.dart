import 'package:complaints_project/Widgets/actionbattons.dart';
import 'package:complaints_project/Widgets/colors.dart';
import 'package:flutter/material.dart';

class EditPost extends StatefulWidget {
  const EditPost({Key? key}) : super(key: key);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  GlobalKey<FormState> _form= GlobalKey<FormState>();
  var desc=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorForDesign().lightblue,
      appBar: AppBar(
        title: Text("Edit Post", style: TextStyle(color: ColorForDesign().white,),),
        centerTitle: true,
        backgroundColor: ColorForDesign().blue,
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
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
                text: 'SAVE',
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
