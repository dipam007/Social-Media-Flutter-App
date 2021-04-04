import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/Animation/FadeAnimation.dart';
import 'package:social_media_app/check_internet_connectivity/checkInternetConnectivity.dart';
import 'file:///C:/Users/aa/AndroidStudioProjects/social_media_app/lib/Services/auth.dart';
import 'package:social_media_app/dashboard.dart';
import 'package:social_media_app/lottieJsonAnimations/lottieLoading.dart';
import 'file:///C:/Users/aa/AndroidStudioProjects/social_media_app/lib/Services/database.dart';
import 'package:social_media_app/signin.dart';
import 'package:path/path.dart' as path;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  final AuthService _auth = AuthService();

  bool key=true;
  Color _color;

  File _image;
  String imageUrl;

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

  Future<void> _showChoiceDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Make a Choice:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.brown),),
            content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    MaterialButton(
                      height: 50,
                      elevation: 10,
                      color: Colors.white70,
                      shape: OutlineInputBorder(),
                      child: Text("Gallary", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,color: Colors.indigo[800])),
                      onPressed: (){
                        _openGallary(context);
                      },
                    ),
                    SizedBox(height: 8,),
                    MaterialButton(
                      height: 50,
                      elevation: 10,
                      shape: OutlineInputBorder(),
                      color: Colors.white70,
                      child: Text("Camara", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,color: Colors.indigo[800])),
                      onPressed: (){
                        _openCamara(context);
                      },
                    ),
                  ],
                )
            ),
          );
        }
    );
  }

  _openGallary(BuildContext context) async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      _image = image;
    });
    Navigator.of(context).pop();
  }
  _openCamara(BuildContext context) async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      _image = image;
    });
    Navigator.of(context).pop();
  }

  Widget _decideImageView(BuildContext context){
    if(_image == null){
      return Icon(Icons.account_circle);
    }
    else{
      return Container(
        width: 250.0,
        height: 240.0,
        decoration:  BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(200)),
            image: DecorationImage(
                fit: BoxFit.fill,
                image: FileImage(_image)
            )
        ),
      );
    }
  }

  Future uploadPic(BuildContext context) async{
    StorageReference storageReference = FirebaseStorage.instance.ref().child('profiles/${path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL){
      setState(() {
        imageUrl = fileURL;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? LottieLoading() : Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
        leading: Icon(Icons.group_add, size: 35.0,),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(5.0, 25.0, 5.0, 20.0),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 70,
                      child: ClipOval(child: _image!=null ? _decideImageView(context) : Icon(Icons.account_circle, size: 140.0,) ),
                    ),
                    Positioned(
                        bottom: 1,
                        right: 1 ,
                        child: Container(
                          height: 40, width: 40,
                          child: IconButton(
                              icon: Icon(Icons.add_a_photo, color: Colors.white,),
                              onPressed: (){
                                _showChoiceDialog(context);
                              }),
                          decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                        )
                    )
                  ],
                ),
              FadeAnimation(1.3, Container(
                  margin: EdgeInsets.only(top: 10.0),
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
                  padding: EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
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
            FadeAnimation(1.0, Container(
                  padding: EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Enter your Name",
                      prefixIcon: Icon(
                        Icons.person,
                        size: 30,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
            ),
            FadeAnimation(0.8, Container(
                  padding: EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: "Enter your Phone Number",
                      prefixIcon: Icon(
                        Icons.phone,
                        size: 30,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
            ),
            FadeAnimation(0.4, Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: RaisedButton(
                      splashColor: Colors.blueAccent,
                      padding: EdgeInsets.all(10.0),
                      color: Colors.pink[400],
                      child: Center(
                        child: Text("Sign Up", style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                      onPressed: () async{
                        setState(() {
                          loading=true;
                        });
                         final email = _emailController.text.toString();
                         final password = _passwordController.text.toString();
                         final name = _nameController.text.toString();
                         final phone = _phoneController.text.toString();

                        //in following dynamic result we take user
                          await uploadPic(context);

                            dynamic result = await _auth.registerWithEmailAndPassword(email, name, phone, password);

                            setState(() {
                              _emailController.text = '';
                              _nameController.text = '';
                              _phoneController.text = '';
                              _passwordController.text = '';
                            });

                            if (result != null && imageUrl!=null) {
                              //create a new document for the user with the uid
                              await DatabaseService(uid: result.uid).updateUserData(email, name, phone, imageUrl);
                              setState(() {
                                loading=false;
                              });

                              return Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashBoard(uid: result.uid,)));
                            }
                            else {
                              return Center(child: CircularProgressIndicator());
                            }
                      }
                  ),
                ),
            ),
            FadeAnimation(0.1, Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  alignment: Alignment.bottomRight,
                  child: OutlinedButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignIn()));
                    },
                    child: Text("Already have an Account", style: TextStyle(fontSize: 15.0),),
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
