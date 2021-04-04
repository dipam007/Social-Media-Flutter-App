import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/signin.dart';
import 'file:///C:/Users/aa/AndroidStudioProjects/social_media_app/lib/Services/user.dart';


class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    return user!=null ? User(uid: user.uid) : CircularProgressIndicator();
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async{
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser  user = result.user;

      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('uid', user.uid);

      _userFromFirebaseUser(user);
      return user.uid;
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email,String name,String phone,String password) async{
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser  user = result.user;

      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('uid', user.uid);

      //create a new document for the user with the uid
      // await DatabaseService(uid: user.uid).updateUserData(email,name,phone);
      return _userFromFirebaseUser(user);
      //return user.uid;
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut(BuildContext context) async{
    try{
      await _auth.signOut().then((value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => new SignIn()));
        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => new SignIn()));
      });

      //Future<FirebaseUser> user = _auth.currentUser();
      // StreamProvider<User>.value(
      //     value: AuthService().user,
      //     child: new MaterialApp(
      //         debugShowCheckedModeBanner: false,
      //         home: new  Wrapper()
      //     )
      // );
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

}
