import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'file:///C:/Users/aa/AndroidStudioProjects/social_media_app/lib/Services/auth.dart';
import 'package:social_media_app/check_internet_connectivity/checkInternetConnectivity.dart';

class Profile extends StatefulWidget {

  final String uid,userName;
  Profile({this.uid, this.userName});
  @override
  _ProfileState createState() => _ProfileState(uid: uid,userName: userName);
}

class _ProfileState extends State<Profile> {

  final String uid,userName;
  _ProfileState({this.uid,this.userName});

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    InternetConnectivity(context: context).checkInternetConnectivity();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10.0,
        backgroundColor: Colors.redAccent,
        title: userName!=null ? Text(userName,style: TextStyle(
            fontSize: 25.0,
            color:Colors.white,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w400
        ),) :  Text('MY PROFILE',style: TextStyle(
            fontSize: 25.0,
            color:Colors.white,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w400
        ),),
        leading: Icon(Icons.tag_faces, size: 32, color: Colors.white,),
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
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              height: MediaQuery.of(context).size.height*0.5,
              child: StreamBuilder<QuerySnapshot>  (
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
                    return Center(child: CircularProgressIndicator());
                  }
                  if(snapshot.data.documents.length==0)
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

                          return user.data['uid']==uid ?
                            SafeArea(
                                child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:  AssetImage('assets/images/9.jpg'),
                                                fit: BoxFit.cover
                                            )
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          height: MediaQuery.of(context).size.height*0.26,
                                          child: Container(
                                            alignment: Alignment(0.0,4.5),
                                            child: CircleAvatar(
                                              backgroundImage: user.data['profileImageUrl'] != null ? NetworkImage(user.data['profileImageUrl'],) : Icon(Icons.account_circle, size: 50.0, color: Colors.blue,),
                                              radius: 80.0,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        height: MediaQuery.of(context).size.height*0.1,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            user.data['name']
                                            ,style: TextStyle(
                                              fontSize: 25.0,
                                              color:Colors.blueGrey,
                                              letterSpacing: 2.0,
                                              fontWeight: FontWeight.w400
                                          ),
                                          ),
                                          Text(
                                            user.data['email']
                                            ,style: TextStyle(
                                              fontSize: 18.0,
                                              color:Colors.cyan,
                                              letterSpacing: 1.0,
                                              fontWeight: FontWeight.w400
                                          ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text(
                                            user.data['phone']
                                            ,style: TextStyle(
                                              fontSize: 18.0,
                                              color:Colors.lightGreen,
                                              letterSpacing: 1.0,
                                              fontWeight: FontWeight.w400
                                          ),
                                          ),
                                        ],
                                      ),

                                      // RaisedButton(
                                      //   child: Text("Posts"),
                                      //     onPressed: (){
                                      //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => Posts(uid: uid,)));
                                      //     }
                                      // ),

                                    ]
                                )
                            ) : Container();

                            // return Card(
                            //     elevation: 10.0,
                            //     color: Colors.white,
                            //     margin: user.data['uid']==uid ? EdgeInsets.all(10.0) : EdgeInsets.all(0.0),
                            //     child: user.data['uid']==uid ? ListTile(
                            //       contentPadding: EdgeInsets.all(8.0),
                            //       leading: user.data['profileImageUrl'] != null ? Image.network(user.data['profileImageUrl']) : Icon(Icons.account_circle, size: 50.0, color: Colors.blue,),
                            //       title: Text("Name: " + user.data['name']),
                            //       subtitle: Text("Mobile:" + user.data['phone']+"\nEmail:"+user.data['email']),
                            //     ) : SizedBox(height: 0.0,)
                            // );
                          },
                        ),
                      );
                },
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              height: MediaQuery.of(context).size.height*0.5,
              child: StreamBuilder<QuerySnapshot>  (
                stream: Firestore.instance.collection('posts').document("ImagePosts").collection(uid).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){

                  print("HasData: ${snapshot.hasData}");
                  print("Data: ${snapshot.data}");
                  print("HasError: ${snapshot.hasError}");
                  print("Error: ${snapshot.error}");

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
                    return Center(
                      child: Text(
                          "Loading...",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          )
                      ),
                    );
                  }
                  if(snapshot.data.documents.length==0)
                  {
                    return Center(
                      child: Text(
                        "No Posts...",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot posts = snapshot.data.documents[index];
                      return Card(
                          elevation: 10.0,
                          margin: EdgeInsets.all(10.0),
                          child:  Image.network(posts.data['postUrl'], fit: BoxFit.fill,)
                      );
                    },
                  );

                  // return Container(
                  //   child: ListView.builder(
                  //     itemCount: snapshot.data.documents.length,
                  //     itemBuilder: (BuildContext context, int index){
                  //
                  //       DocumentSnapshot posts = snapshot.data.documents[index];
                  //
                  //       print(posts.data['post time']);
                  //       return Card(
                  //           elevation: 10.0,
                  //           color: Colors.white,
                  //           margin: EdgeInsets.all(10.0),
                  //           child:  Image.network(posts.data['postUrl'])
                  //       );
                  //     },
                  //   ),
                  // );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

