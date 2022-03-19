
import 'dart:convert';
import 'dart:io';

import 'package:complaints_project/Model/user_info.dart';
import 'package:complaints_project/Widgets/actionbattons.dart';
import 'package:complaints_project/Widgets/colors.dart';
import 'package:complaints_project/Widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  List<UserInfoApi>? user;
  ProfileScreen({Key? key,this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> _form= GlobalKey<FormState>();
  GlobalKey<FormState> _form2= GlobalKey<FormState>();
  GlobalKey<FormState> _form3= GlobalKey<FormState>();
  GlobalKey<FormState> _form4= GlobalKey<FormState>();
  var fname=TextEditingController();
  var phnum=TextEditingController();
  var email=TextEditingController();
  var pass=TextEditingController();
  var pass2=TextEditingController();
  bool ob = true,ob2= true;
  var confpass;
  Icon iconpass = Icon(Icons.visibility,color: ColorForDesign().blue,);
  Icon iconpass2 = Icon(Icons.visibility,color: ColorForDesign().blue,);
  bool _load = false;
  File ? imageFile;
  final imagePicker = ImagePicker();
  String status = '';
  String photo = '';
  String imagepath = '';

  void _showErrorSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(Icons.error_outline, size: 20,color: Colors.black,),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              "You must login first",
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

  Future chooseImage(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);
    setState(() {
      imageFile = File(pickedFile!.path);
      _load = false;
    });
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }


  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose profile image",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                chooseImage(ImageSource.gallery);
                Navigator.pop(context);
              },
              label: Text("gallery",style: TextStyle(),),

            ),
          ])
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorForDesign().lightblue,
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          child: widget.user!.isEmpty || widget.user == null ?
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
                if(widget.user!.isEmpty || widget.user == null){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                    ],
                  );
                }else{
                  fname.text = userApi.name;
                  phnum.text = userApi.phone;
                  email.text = userApi.email;
                  return Column(
                    children: [
                      Center(
                        child: Center(
                          child: Stack(children: <Widget>[
                            imageFile == null ?
                            ClipOval(
                              child: Image.network('https://abulsamrie11.000webhostapp.com/image/${userApi.image}',
                                width: 175,
                                height: 175,
                                fit: BoxFit.cover,
                              ),

                            ) :CircleAvatar(
                              radius: 80.0,
                              backgroundImage: FileImage(File(imageFile!.path)),

                            ),
                            Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              child: Row(
                                children: [
                                  imageFile == null ?
                                  InkWell(
                                    onTap: () async {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: ((builder) => bottomSheet()),
                                      );

                                    },
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                      size: 30.0,
                                    ),
                                  )
                                      :
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: ((builder) => bottomSheet()),

                                          );

                                        },
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 30.0,
                                        ),
                                      ),
                                      Padding(padding: const EdgeInsets.only(left: 10),
                                        child: InkWell(
                                          onTap: () async {

                                            // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                            // int? id= sharedPreferences.getInt('userID');
                                            // if (imageFile == null ) return ;
                                            // photo = base64Encode(imageFile!.readAsBytesSync());
                                            // imagepath = imageFile!.path.split("/").last;
                                            // updateImage(id!, imagepath, photo);
                                            // imageCache!.clear();
                                            // sharedPreferences.setString('profile_photo_path', imagepath);

                                          },
                                          child: const Icon(
                                            Icons.done,
                                            color: Color.fromARGB(250, 9, 85, 245),
                                            size: 30.0,
                                          ),
                                        ),),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          ]),
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Column(
                        children: <Widget>[
                          Form(
                            key: _form,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  hintText: userApi.name,
                                  hintStyle: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: Icon(Icons.person,color: ColorForDesign().blue,),
                                ),
                                validator: (value){
                                  if(value!.isEmpty) {
                                    return "Required";
                                  }
                                },
                                controller: fname,
                              ),
                            ),),
                          Form(
                            key: _form2,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  hintText: 'Phone Number',
                                  hintStyle: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: Icon(Icons.phone,color: ColorForDesign().blue,),
                                ),
                                validator: (value){
                                  if(value!.isEmpty) {
                                    return "Required";
                                  }
                                },
                                controller: phnum,
                              ),
                            ),),
                          Form(
                            key: _form3,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                readOnly: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  hintText: 'Email',
                                  hintStyle: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: Icon(Icons.email,color: ColorForDesign().blue,),
                                ),
                                validator: (value){
                                  if(value!.isEmpty) {
                                    return "Required";
                                  }
                                },
                                controller: email,
                              ),
                            ),),
                          Form(
                            key: _form4,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(0),
                                      hintText: "Password",
                                      hintStyle: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                      fillColor: Colors.white,
                                      focusColor: Colors.white,
                                      filled: true,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (ob == true) {
                                              ob = false;
                                              iconpass = Icon(Icons.visibility_off,color: ColorForDesign().blue,);
                                            } else {
                                              ob = true;
                                              iconpass = Icon(Icons.visibility,color: ColorForDesign().blue,);
                                            }
                                          });
                                        },
                                        icon: iconpass,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: Icon(Icons.lock,color: ColorForDesign().blue,),
                                    ),
                                    validator: (value){
                                      confpass = value;
                                      if(value!.isEmpty) {
                                        return "Required";
                                      }
                                    },
                                    obscureText: ob,
                                    controller: pass,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(0),
                                      hintText: "Confirm Password",
                                      hintStyle: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                      fillColor: Colors.white,
                                      focusColor: Colors.white,
                                      filled: true,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (ob2 == true) {
                                              ob2 = false;
                                              iconpass2 = Icon(Icons.visibility_off,color: ColorForDesign().blue,);
                                            } else {
                                              ob2 = true;
                                              iconpass2 = Icon(Icons.visibility,color: ColorForDesign().blue,);
                                            }
                                          });
                                        },
                                        icon: iconpass2,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: Icon(Icons.lock,color: ColorForDesign().blue,),
                                    ),
                                    validator: (value){
                                      if(value!.isEmpty) {
                                        return "Required";
                                      }else if(value != confpass){
                                        return "Password does't match !";
                                      }
                                    },
                                    obscureText: ob2,
                                    controller: pass2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Builder(
                            builder: (context) => Center(
                              child: ButtonWidget(
                                text: 'SAVE',
                                width: 150,
                                onClicked: () async {
                                  if(_form.currentState!.validate() && _form2.currentState!.validate() && _form3.currentState!.validate()){
                                    if(pass.text.isNotEmpty){
                                      if(_form4.currentState!.validate()){
                                        print('Save with password');
                                      }
                                    }else{
                                      print('Save without password');
                                    }
                                  }

                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  );

                }
              },
          ),
        ),
      ),
    );
  }
}
