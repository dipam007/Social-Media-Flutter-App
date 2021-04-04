import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///C:/Users/aa/AndroidStudioProjects/social_media_app/lib/Services/user.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection = Firestore.instance.collection('users');

  Future updateUserData(String email,String name,String phone,String profileImageUrl) async{
    return await brewCollection.document(uid).setData({
      'uid' : uid,
      'email' : email,
      'name' : name,
      'phone' : phone,
      'profileImageUrl': profileImageUrl
    });
  }

  //userdata from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      email: snapshot.data['email'],
      name: snapshot.data['name'],
      phone: snapshot.data['phone'],
    );
  }

  //get user doc stream
  Stream<UserData> get userData{
    return brewCollection.document(uid).snapshots()
        .map(_userDataFromSnapshot);
  }

}