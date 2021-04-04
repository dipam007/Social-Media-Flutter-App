import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/check_internet_connectivity/checkInternetConnectivity.dart';

class Posts extends StatefulWidget {

  final String uid;
  Posts({this.uid});
  @override
  _PostsState createState() => _PostsState(uid: uid);
}

class _PostsState extends State<Posts> {

  final String uid;
  _PostsState({this.uid});

  final firestoreInstance = Firestore.instance;

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
        backgroundColor: Colors.cyan,
        title: Text(
          "Posts",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>  (
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
    );
  }
}
