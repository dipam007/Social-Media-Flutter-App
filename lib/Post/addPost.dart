import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/Animation/FadeAnimation.dart';
import 'package:path/path.dart' as path;
import 'package:social_media_app/check_internet_connectivity/checkInternetConnectivity.dart';
import 'package:social_media_app/dashboard.dart';
import 'package:social_media_app/lottieJsonAnimations/lottieLoading.dart';

class AddPost extends StatefulWidget {

  final String uid;
  AddPost({this.uid});
  @override
  _AddPostState createState() => _AddPostState(uid: uid);
}

class _AddPostState extends State<AddPost> {

  final String uid;
  _AddPostState({this.uid});

  final fireStoreInstance = Firestore.instance;

  File _image;
  String imageUrl;

  String _timeString;
  bool loadingImage;

  @override
  void initState() {
    super.initState();
    InternetConnectivity(context: context).checkInternetConnectivity();
    setState(() {
      _timeString = _formatDateTime(DateTime.now());
      loadingImage = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd:hh:mm:ss').format(dateTime);
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
            borderRadius: BorderRadius.all(Radius.circular(0)),
            image: DecorationImage(
                fit: BoxFit.fill,
                image: FileImage(_image)
            )
        ),
      );
    }
  }

  Future<String> uploadImage(var imageFile) async {
    try {
      StorageReference ref = FirebaseStorage.instance.ref().child(
          'posts/${path.basename(_image.path)}');
      StorageUploadTask uploadTask = ref.putFile(_image);
      final dowUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      return dowUrl.toString();
    }
    catch(e){
      print(e);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return loadingImage ? LottieLoading() : Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
        centerTitle: true,
        leading: Icon(Icons.add_photo_alternate, size: 35.0,),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(5.0, 25.0, 5.0, 20.0),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _image!=null ? _decideImageView(context) : Icon(Icons.account_circle, size: 140.0,),

                        IconButton(
                              icon: Icon(Icons.add_a_photo, color: Colors.blueAccent,),
                              iconSize: 100,
                              onPressed: (){
                                _showChoiceDialog(context);
                              }
                          ),

                  ],
                ),

                FadeAnimation(0.4, Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: RaisedButton(
                      splashColor: Colors.blueAccent,
                      padding: EdgeInsets.all(10.0),
                      color: Colors.pink[400],
                      child: Center(
                        child: Text("ADD POST", style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                      onPressed: () async {

                          setState(() {
                            loadingImage = true;
                          });

                           imageUrl = await uploadImage(_image);
                           setState(() {
                             _timeString = _formatDateTime(DateTime.now());
                           });

                          fireStoreInstance.collection("posts").document("ImagePosts").collection(uid).document(_timeString).setData(
                              {
                                "uid": uid,
                                "postUrl": imageUrl,
                                "post time": _timeString
                              })
                              .then((_) {
                            print("success!"+imageUrl);
                          });
                          setState(() {
                            loadingImage = false;
                          });
                          return Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DashBoard(uid: uid,)));
                        }
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
