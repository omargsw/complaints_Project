import 'dart:convert';
import 'package:complaints_project/Screens/nav_bar.dart';
import 'package:complaints_project/Widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static const route = '/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool isclick = false;

  GlobalKey<FormState> _form= GlobalKey<FormState>();
  var email=TextEditingController();
  var pass=TextEditingController();

  bool ob=true;
  var userId;
  Icon iconpass = Icon(Icons.visibility,color: ColorForDesign().blue);

  Future<bool> loginIn(var email, var pass) async {
    String url = 'https://abulsamrie11.000webhostapp.com/onTheGo/login.php';
    final response = await http.post(Uri.parse(url), body: {
      "email": email.toString(),
      "password": pass,
    });
    var json = jsonDecode(response.body);
    if(json['error']){
      _showErrorDialog("Invalid user name or password");
    } else {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setInt('userID', json['user']['id']);
      sharedPreferences.setString('name', json['user']['name'] );
      sharedPreferences.setString('email', json['user']['email'] );
      sharedPreferences.setString('phone', json['user']['phone'] );
      sharedPreferences.setString('image', json['user']['image'] );
      sharedPreferences.setInt('typeID', json['user']['user_type_id'] );

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => const NavBar()),
              (Route<dynamic> route) => false);
    }
    return true;
  }

  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(msg),
        //  content:
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: (){
                setState(() {
                  isclick = false;
                });
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
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: ColorForDesign().blue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 60,),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Login", style: TextStyle(color: ColorForDesign().white, fontSize: 40,),),
                  const SizedBox(height: 10,),
                  Text("Welcome Back", style: TextStyle(color: ColorForDesign().white, fontSize: 20,)),
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
                        topRight: Radius.circular(60),
                    )

                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _form,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 60,),
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
                                  padding: const EdgeInsets.all(10),
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
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle: const TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
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
                                    ),
                                    controller: pass,
                                    validator: (value){
                                      if(value!.isEmpty) {
                                        return "Please Enter Password";
                                      }
                                    },
                                    obscureText: ob,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15,),
                          isclick ? const CircularProgressIndicator() : Container(),
                          const SizedBox(height: 15,),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     TextButton(
                          //       style: TextButton.styleFrom(
                          //         textStyle: const TextStyle(fontSize: 15),
                          //       ),
                          //       onPressed: () {
                          //
                          //       },
                          //       child: const Text('Forgot Password ?'),
                          //     ),
                          //   ],
                          // ),
                          RaisedButton(
                            onPressed: () async {
                              if (!_form.currentState!.validate()) {
                                // Invalid!
                                return;
                              }else if(_form.currentState!.validate()) {
                                loginIn(email.text, pass.text);
                                _form.currentState!.save();
                              }
                              setState(() {
                                isclick = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left:75,right:75),
                              child: Text("Login",style: TextStyle(color: ColorForDesign().white,),),
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
                                    builder: (context)=>SignUp(),
                                  )
                              );
                            },
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                    text: 'Don\'t have an account?',
                                    style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18,),
                                    children: [
                                      TextSpan(
                                        text: 'SIGN UP',
                                        style: TextStyle(
                                          color: ColorForDesign().blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Image.asset('assets/images/logo.jpeg',
                            height: 150,
                            width: 150,
                          ),

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
