import 'package:cloud_firestore/cloud_firestore.dart';

class SearchServices {
  searchByName(String searchField){
    return Firestore.instance.collection('clientNames').where('searchKey', isEqualTo: searchField.substring(0,1)).getDocuments();
  }
}