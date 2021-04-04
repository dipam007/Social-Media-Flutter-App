import 'package:flutter/material.dart';
import 'package:social_media_app/Animation/FadeAnimation.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _email,_pass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new AssetImage("assets/images/7.jpg"),)
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10,bottom: 20),
                child: FadeAnimation(2, Container(
                    width: 140,
                    height: 100,
                    decoration:  new BoxDecoration(
                      image:new DecorationImage(
                          fit: BoxFit.fill,
                          image: new AssetImage("assets/images/.jpg"
                          )),
                    ))),
              ),
              Stack(
                children: <Widget>[
                  SingleChildScrollView(
                      child: FadeAnimation(2.3, Container(
                        height: 300.0,
                        width: 340.0,
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 20.0
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xffff9232),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25.0)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: FadeAnimation(2.8,  TextField(
                                autocorrect: false,

                                autofocus: false,
                                style: TextStyle(
                                    fontSize: 20.0
                                ),
                                decoration: InputDecoration(
                                    hintText: "Username",
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    contentPadding: EdgeInsets.all(15.0)
                                ),
                              )),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 3.0),
                                child: FadeAnimation(3.3, TextField(
                                  autocorrect: false,
                                  autofocus: false,
                                  obscureText: true,
                                  style: TextStyle(
                                      fontSize: 20.0
                                  ),
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      contentPadding: EdgeInsets.all(15.0)
                                  ),
                                ))),
                            Container(
                              padding: EdgeInsets.only(top: 5),
                            ),
                            Container(
                                child: FadeAnimation(3.8 ,Padding(
                                    padding: EdgeInsets.symmetric(vertical:10 ),
                                    child:MaterialButton(
                                      onPressed: (){},
                                      color: Colors.red,
                                      minWidth: 150.0,
                                      splashColor: Colors.cyan,
                                      padding: EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text("Login",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white
                                        ),),)
                                ))),
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: FadeAnimation(4.3, Row(
                                  children: <Widget>[
                                    Container(
                                      child: MaterialButton(
                                        splashColor: Colors.blueAccent,
                                        color: Color(0x80deccad),
                                        onPressed: (){},
                                        child: Text("New Users" ,
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                decoration: TextDecoration.underline,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400
                                            )
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 5),
                                    ),
                                    Container(
                                      child: MaterialButton(
                                        color: Color(0x80ffa366),
                                        splashColor: Colors.black38,
                                        onPressed: (){},
                                        child:  Text("Forgot Password ?",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700
                                          ),),
                                      ),
                                    ),
                                  ],
                                ))),
                          ],
                        ),
                      ),
                      ))
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
