import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/check_internet_connectivity/checkInternetConnectivity.dart';
import 'package:social_media_app/loading.dart';
import 'file:///C:/Users/aa/AndroidStudioProjects/social_media_app/lib/Message/messagePage.dart';

class MessageUserList extends StatefulWidget {
  @override
  _MessageUserListState createState() => _MessageUserListState();
}

class _MessageUserListState extends State<MessageUserList> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  String myId;
  String myName;

  @override
  void initState() {
    // TODO: implement initState
    InternetConnectivity(context: context).checkInternetConnectivity();
    super.initState();
    setFirebaseUser();
    setMyId();
  }

  @override
  void dispose() {
    super.dispose();
  }

  setFirebaseUser() async{
    firebaseUser = await _firebaseAuth.currentUser();
  }

  setMyId() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      myId = preferences.getString('uid');
      myName = preferences.getString('userName');
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      margin: user.data['uid']!=myId ? EdgeInsets.all(10.0) : EdgeInsets.all(0.0),
                      child: user.data['uid']!=myId ? ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        leading: CircleAvatar(
                          radius: 25.0,
                          backgroundImage: user.data['profileImageUrl'] != null ? NetworkImage(user.data['profileImageUrl']) : Icon(Icons.account_circle,),
                        ),
                        title: Text("Name: " + user.data['name']),
                        subtitle: Text("Mobile:" + user.data['phone']+"\nEmail:"+user.data['email']),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessagePage(user: firebaseUser, receiverId: user.data['uid'],receiverName: user.data['name'], image: user.data['profileImageUrl'],)));
                        },
                      ) : SizedBox(height: 0.0,)
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
