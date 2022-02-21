import 'dart:convert';

import 'package:complaints_project/Widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  bool isLoading = false;
  bool isclick = false;

  final GlobalKey<FormState> _form= GlobalKey<FormState>();

  String ? verificationId;

  bool showLoading = false;
  bool ob=true;
  bool ob2=true;
  Icon iconpass = const Icon(Icons.visibility);
  Icon iconpass2 = const Icon(Icons.visibility);
  var email=TextEditingController();
  var pass=TextEditingController();
  var pass2=TextEditingController();
  var name=TextEditingController();
  var num=TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(msg,style: TextStyle(fontSize: 15,color: Colors.black),),
          //  content:
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: (){
                Navigator.of(ctx).pop();
              },
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: ColorForDesign().blue,

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80,),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("SignUp", style: TextStyle(color: ColorForDesign().white, fontSize: 40,),),
                  const SizedBox(height: 10,),
                  Text("Welcome", style: TextStyle(color: ColorForDesign().white, fontSize: 20,),),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: ColorForDesign().white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(60)
                    )

                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _form,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 60,),
                          Container(
                            decoration: BoxDecoration(
                                color: ColorForDesign().white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 20,
                                    offset: Offset(0, 10)
                                )]
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.black12))
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                        hintText: "Email",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none
                                    ),
                                    validator: (value){
                                      if(value!.isEmpty) {
                                        return "Please Enter Your Email";
                                      } else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                                        return "Please Enter The Correct Email ";
                                      }
                                    },

                                    controller: email,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.black12))
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.name,
                                    decoration: const InputDecoration(
                                        hintText: "Name",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none
                                    ),
                                    validator: (value){
                                      if(value!.isEmpty) {
                                        return "Please enter your name";
                                      }
                                    },

                                    controller: name,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.black12))
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                        hintText: "Phone Number",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none
                                    ),
                                    validator: (value){
                                      if(value!.isEmpty) {
                                        return "The phone number must be 10 digits";
                                      }
                                    },

                                    controller: num,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.black12))
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
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
                                          icon: iconpass ,
                                        ),
                                        hintText: "Password",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none

                                    ),
                                    controller: pass,
                                    validator: (value){
                                      if(value!.isEmpty) {
                                        return "Please Enter The Password";
                                      }
                                    },
                                    obscureText: ob,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      hintText: "Confirm Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
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
                                        icon: iconpass2 ,
                                      ),
                                    ),
                                    controller: pass2,
                                    validator: (value){
                                      if(pass.text == value) {
                                        return null;
                                      }else{
                                        return "Password doesn't match";
                                      }
                                    },
                                    obscureText: ob2,
                                  ),
                                ),
                              ],
                            ),

                          ),
                          const SizedBox(height: 15,),
                          isclick ? const CircularProgressIndicator() : Container(),
                          const SizedBox(height: 20,),
                          RaisedButton(
                            onPressed: () async {
                              var nametxt = name.text;
                              var emailtxt = email.text;
                              var passwordtxt = pass.text;
                              var phonetxt = num.text;
                              print(nametxt);
                              print(emailtxt);
                              print(passwordtxt);
                              print(phonetxt.toString());
                              if (!_form.currentState!.validate()) {
                                // Invalid!
                                return;
                              }else {


                                setState(() {
                                  isclick = true;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left:75,right:75),
                              child: Text("SignUp",style: TextStyle(color: ColorForDesign().white,),),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            color: ColorForDesign().blue,
                          ),
                          const SizedBox(height: 20,),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context)=>LoginScreen(),
                                  )
                              );
                            },
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                    text: 'Do you have an account?',
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18,),
                                    children: [
                                      TextSpan(
                                        text: 'LOGIN',
                                        style: TextStyle(
                                          color: ColorForDesign().blue,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Simpletax',
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
