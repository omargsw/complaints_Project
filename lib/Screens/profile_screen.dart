import 'dart:io';
import 'package:complaints_project/Model/user_info.dart';
import 'package:complaints_project/Widgets/actionbattons.dart';
import 'package:complaints_project/Widgets/colors.dart';
import 'package:complaints_project/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../Widgets/appbar.dart';
import 'login_screen.dart';
import 'nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  final List<UserInfoApi>? user;
  bool show;
  ProfileScreen({Key? key,this.user,required this.show}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var id = sharedPreferences!.getInt('userID');
  GlobalKey<FormState> _form= GlobalKey<FormState>();
  GlobalKey<FormState> _form2= GlobalKey<FormState>();
  GlobalKey<FormState> _form3= GlobalKey<FormState>();
  GlobalKey<FormState> _form4= GlobalKey<FormState>();
  var fname=TextEditingController();
  var phnum=TextEditingController();
  var email=TextEditingController();
  var pass1=TextEditingController();
  var pass2=TextEditingController();
  var pass3=TextEditingController();
  bool ob = true,ob2= true,ob3= true;
  var confpass;
  Icon iconpass = Icon(Icons.visibility,color: ColorForDesign().blue,);
  Icon iconpass2 = Icon(Icons.visibility,color: ColorForDesign().blue,);
  Icon iconpass3 = Icon(Icons.visibility,color: ColorForDesign().blue,);

  bool _load = false;
  File ? imageFile;
  final imagePicker = ImagePicker();
  String status = '';
  String photo = '';
  String imagepath = '';

  List<UserInfoApi> user = [];
  Future UserInfo() async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/UserInfo.php?userid=${id.toString()}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<UserInfoApi> userlist = userInfoApiFromJson(response.body);
      return userlist;
    }
  }

  void _showDoneSnackBar(BuildContext context,String text) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.done_outline, size: 20,color: Colors.green,),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15,color: Colors.green),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black45,
      duration: const Duration(seconds: 3),
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

  Future updateName(int id, var name) async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/updatename.php';
    final response = await http.post(Uri.parse(url),
        body: {"id": id.toString(), "name": name});

    print('UPDATE-NAME------>' + response.body);
  }

  Future updatePhone(int id, var phone) async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/updatephone.php';
    final response = await http.post(Uri.parse(url),
        body: {"id": id.toString(), "phone": phone});

    print('UPDATE-PHONE------>' + response.body);
  }

  Future updatePassword(int id, var password) async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/updatepassword.php';
    final response = await http.post(Uri.parse(url),
        body: {"id": id.toString(), "password": password});

    print('UPDATE-PASSWORD------>' + response.body);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorForDesign().lightblue,
      appBar: AppAppBar(title: "Edit Profile",show: widget.show),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              }else if(fname.text.length < 4){
                                return "The name must be greater than 4 characters";
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
                              }else if(phnum.text.length != 10){
                                return "Phone number must be 10 numbers";
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextButton(onPressed: (){
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => StatefulBuilder(builder: (context, setState) {
                                return AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                  backgroundColor: ColorForDesign().lightblue,
                                  content: Container(
                                    height: 280,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Form(
                                          key: _form4,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  keyboardType: TextInputType.visiblePassword,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.all(0),
                                                    hintText: "Current Password",
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
                                                    if(value!.isEmpty) {
                                                      return "Required";
                                                    }else if(userApi.password != pass1.text){
                                                      return "The password does't match the current password";
                                                    }
                                                  },
                                                  obscureText: ob,
                                                  controller: pass1,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  keyboardType: TextInputType.visiblePassword,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.all(0),
                                                    hintText: "New Password",
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
                                                    confpass = value;
                                                    if(value!.isEmpty) {
                                                      return "Required";
                                                    }
                                                  },
                                                  obscureText: ob2,
                                                  controller: pass2,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  keyboardType: TextInputType.visiblePassword,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.all(0),
                                                    hintText: "Confirm the new password ",
                                                    hintStyle: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                                    fillColor: Colors.white,
                                                    focusColor: Colors.white,
                                                    filled: true,
                                                    suffixIcon: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          if (ob3 == true) {
                                                            ob3 = false;
                                                            iconpass3 = Icon(Icons.visibility_off,color: ColorForDesign().blue,);
                                                          } else {
                                                            ob3 = true;
                                                            iconpass3 = Icon(Icons.visibility,color: ColorForDesign().blue,);
                                                          }
                                                        });
                                                      },
                                                      icon: iconpass3,
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
                                                  obscureText: ob3,
                                                  controller: pass3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('CANCEL',
                                              style: TextStyle(
                                                color: ColorForDesign().blue,
                                              )),
                                        ),
                                        TextButton(
                                          onPressed: ()async{
                                            if(_form4.currentState!.validate()){
                                              await updatePassword(id!, pass3.text);
                                              _showDoneSnackBar(context, "Password changed successfully");
                                              pass1.clear();
                                              pass2.clear();
                                              pass3.clear();
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Text('SAVE',
                                              style: TextStyle(
                                                color: ColorForDesign().blue,
                                              )),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },));
                        }, child: const Text("Edit Password",style: TextStyle(decoration: TextDecoration.underline),)),
                      ),
                      Builder(
                        builder: (context) => Center(
                          child: ButtonWidget(
                            text: 'SAVE',
                            width: 150,
                            onClicked: () async {
                              if(_form.currentState!.validate() && _form2.currentState!.validate()){
                                await updateName(id!, fname.text);
                                await updatePhone(id!, phnum.text);
                                _showDoneSnackBar(context, "Profile modified successfully");
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (BuildContext context) => const NavBar()),);
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
    );
  }
}
