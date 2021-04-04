import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/aa/AndroidStudioProjects/social_media_app/lib/Search/searchService.dart';
import 'package:social_media_app/check_internet_connectivity/checkInternetConnectivity.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  var queryResultSet = [];
  var tempSearchStore = [];

  @override
  void initState() {
    super.initState();
    InternetConnectivity(context: context).checkInternetConnectivity();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initiateSearch(value)
  {
      if(value.length==0){
        setState(() {
          queryResultSet = [];
          tempSearchStore = [];
        });
      }

      var capitalizedValue = value.substring(0,1) + value.substring(1);

      if(queryResultSet.length == 0 && value.length == 1){
         SearchServices().searchByName(value).then((QuerySnapshot docs) {
           for(int i=0;i<docs.documents.length;i++){
             queryResultSet.add(docs.documents[i].data);
           }
           print(queryResultSet);
         });
      }
      else{
        tempSearchStore = [];
        queryResultSet.forEach((element) {
          if(element['name'].startsWith(capitalizedValue)){
            setState(() {
              tempSearchStore.add(element);
            });
          }
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search")
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val){
                setState(() {
                  initiateSearch(val);
                });
              },
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0,
                    onPressed: (){
                      Navigator.of(context).pop();
                    }
                    ),
                contentPadding: EdgeInsets.only(left: 25.0),
                hintText: 'Search by name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0)
                )
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          GridView.count(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
              crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            primary: false,
            shrinkWrap: true,
            children: tempSearchStore.map((e) {
              return buildResultCard(e);
            }).toList()
          )
        ],
      ),
    );
  }
}

Widget buildResultCard(data){
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    elevation: 2.0,
    child: Container(
      child: Center(
          child: Text(data['name'],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0
            ),)
      ),
    ),
  );
}

