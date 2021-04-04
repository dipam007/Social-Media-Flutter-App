import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/check_internet_connectivity/checkInternetConnectivity.dart';
import 'file:///C:/Users/aa/AndroidStudioProjects/social_media_app/lib/Post/addPost.dart';
import 'file:///C:/Users/aa/AndroidStudioProjects/social_media_app/lib/Services/auth.dart';
import 'package:social_media_app/drawer_dart.dart';
import 'package:social_media_app/homeTabbar.dart';
import 'package:social_media_app/loading.dart';
import 'package:social_media_app/lottieJsonAnimations/lottieLoading.dart';
import 'file:///C:/Users/aa/AndroidStudioProjects/social_media_app/lib/Message/messageUserList.dart';
import 'package:social_media_app/profile.dart';
import 'file:///C:/Users/aa/AndroidStudioProjects/social_media_app/lib/Search/search.dart';

class DashBoard extends StatefulWidget {

  final String uid;
  DashBoard({this.uid});
  @override
  _DashBoardState createState() => _DashBoardState(uid: uid);
}

class _DashBoardState extends State<DashBoard> {

  final AuthService _auth = AuthService();

  final String uid;
  _DashBoardState({this.uid});

  String userName;

  Color color;
  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    InternetConnectivity(context: context).checkInternetConnectivity();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _setAppbarColor());
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _setAppbarColor() async{
     Firestore.instance.collection('AppbarColorCode').document('tPIdj7SrX1d9X83bzcEA').get().then((DocumentSnapshot document){
      Color clr;
      if (mounted) setState(() {
        clr = Color(Color(int.parse(document['color_code'])).value);
      });
      if(clr!=color){
        setState(() {
          color=clr;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return uid!=null ? Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: color,
        title: Text("Dashboard",style: TextStyle(
            fontSize: 25.0,
            color:Colors.white,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w400
        ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app, size: 30.0,),
              tooltip: "Logout",
              onPressed: () async {
                SharedPreferences preferences = await SharedPreferences.getInstance();
                preferences.remove('uid');
                 _auth.signOut(context);
              }
            )
        ],
      ),
      drawer: DrawerPage(uid: uid,),
      body: StreamBuilder<QuerySnapshot>  (
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){

          if (snapshot.hasError) {
            return Center(
                child:Text(
                    'Something went wrong',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    )
                )
            );
          }
          if (!snapshot.hasData) {
            return Loading();//return Loading();
          }
          if(snapshot.data.documents.length-1==0)
          {
            return Center(
              child: Text(
                "There are no other Users in this App",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          return Container(
            child: ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index){

                DocumentSnapshot user = snapshot.data.documents[index];


                return Card(
                  elevation: 10.0,
                  color: Colors.white,
                  margin: user.data['uid']!=uid ? EdgeInsets.all(10.0) : EdgeInsets.all(0.0),
                  child: user.data['uid']!=uid ? ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    leading: CircleAvatar(
                      radius: 25.0,
                      backgroundImage: user.data['profileImageUrl'] != null ? NetworkImage(user.data['profileImageUrl']) : Icon(Icons.account_circle,),
                    ),
                    title: Text("Name: " + user.data['name']),
                    subtitle: Text("Mobile:" + user.data['phone']+"\nEmail:"+user.data['email']),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile(uid: user.data['uid'],userName: user.data['name'],)));
                    },
                  ) : SizedBox(height: 0.0,)
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
          notchMargin: 10.0,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 6, 6, 6),
                child: IconButton(
                    icon: Icon(Icons.home),
                    color: Colors.brown[400],
                    iconSize: 38.0,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeTabBar()));
                    }
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 6, 6, 6),
                child: IconButton(
                    tooltip: "TabBarExample",
                    icon: Icon(Icons.message),
                    color: Colors.lightGreen,
                    iconSize: 38.0,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessageUserList()));
                    }
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.fromLTRB(6, 6, 10, 6),
                child: IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.blue,
                    iconSize: 38.0,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Search()));
                    }
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(6, 6, 10, 6),
                child: IconButton(
                    icon: Icon(Icons.account_box),
                    color: Colors.redAccent,
                    iconSize: 38.0,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile(uid: uid,userName: userName)));
                    }
                  ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, size: 32,),
            elevation: 10.0,
            tooltip: "ADD POST",
            backgroundColor: Colors.blue,
            onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPost(uid: uid,)));}
            ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    ) : LottieLoading();
  }
}
