import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_media_app/Animation/FadeAnimation.dart';
import 'package:social_media_app/admin.dart';
import 'package:social_media_app/check_internet_connectivity/checkInternetConnectivity.dart';
import 'check_internet_connectivity/checkInternetConnectivity.dart';
import 'file:///C:/Users/aa/AndroidStudioProjects/social_media_app/lib/Services/auth.dart';
import 'package:social_media_app/dashboard.dart';
import 'package:social_media_app/lottieJsonAnimations/lottieLoading.dart';
import 'package:social_media_app/signup.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _auth = AuthService();

  bool key=true;
  Color _color;

  bool loading;

  @override
  void initState() {
    super.initState();
    InternetConnectivity(context: context).checkInternetConnectivity();
    setState(() {
      loading = false;
    });
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? LottieLoading() : Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        centerTitle: true,
        leading: Icon(Icons.group, size: 32.0,),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(5.0, 25.0, 5.0, 20.0),
            child: Column(
              children: <Widget>[
              FadeAnimation(1.5,Container(
                  padding: EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Enter your Email",
                      prefixIcon: Icon(
                        Icons.email,
                        size: 30,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
              ),
              FadeAnimation(1.2, Container(
                  padding: EdgeInsets.only(bottom: 12.0,left: 12.0, right: 12.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: key,
                    decoration: InputDecoration(
                      hintText: "Enter your Password",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: _color,
                        size: 30,
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: (){
                            key==false ? setState(() {key=true;_color=null;}) : setState(() {key=false;_color=Colors.red;});
                          }
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
              ),
              FadeAnimation(0.8, Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: RaisedButton(
                      splashColor: Colors.blueAccent,
                      padding: EdgeInsets.all(10.0),
                      color: Colors.pink[400],
                      child: Center(
                        child: Text("Sign In", style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                      onPressed: () async{
                        setState(() {
                          loading=true;
                        });
                        final email = _emailController.text.toString();
                        final password = _passwordController.text.toString();

                        dynamic result = await _auth.signInWithEmailAndPassword(email,password);

                        setState(() {
                          _emailController.text='';
                          _passwordController.text='';
                        });

                        if(result!=null){
                          print("Resulttttttttt: ");
                          print(result);
                            setState(() {
                              loading=false;
                            });
                            if(result=='ecQwKcoiejhZ8LKL3WB63YdCGhy2'){
                              return Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminPage()));
                            }
                            else{
                              return Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashBoard(uid: result,)));
                            }

                        }
                        else{
                          return Center(child: CircularProgressIndicator());
                        }
                      }
                  ),
                ),
              ),
              FadeAnimation(0.2, Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  alignment: Alignment.bottomRight,
                  child: OutlinedButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
                          },
                        child: Text("Create an Account", style: TextStyle(fontSize: 15.0),),
                      ),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
