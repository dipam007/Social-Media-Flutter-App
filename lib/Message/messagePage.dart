import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/check_internet_connectivity/checkInternetConnectivity.dart';
import 'package:social_media_app/loading.dart';

class MessagePage extends StatefulWidget {

  final FirebaseUser user;
  final String receiverId;
  final String receiverName;
  final String image;
  const MessagePage({Key key, this.user, this.receiverId, this.receiverName, this.image}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  final Firestore _firestore = Firestore.instance;

  TextEditingController messagecontroller = TextEditingController();
  ScrollController scrollController = ScrollController();

  String _timeString;
  Timer timer;
  Timer timer2;
  var size1;
  var size2;


  @override
  void initState() {
    InternetConnectivity(context: context).checkInternetConnectivity();
    setState(() {
      _timeString = _formatDateTime(DateTime.now());
    });
    size1=0;
    timer2 = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) => controlScrolar());
    super.initState();
  }

  @override
  void dispose() {
    timer2?.cancel();
    timer?.cancel();
    super.dispose();
  }

  controlScrolar(){
    if(size2>size1)
    {
      scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          curve: Curves.bounceInOut,
          duration: Duration(milliseconds: 100)
      );
      setState(() {
        size1=size2;
      });
    }
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    _timeString = formattedDateTime;
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy'+'hh:mm:ss').format(dateTime);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message is empty!!!'),
          // content: SingleChildScrollView(
          //   child: ListBody(
          //     children: <Widget>[
          //       Text('This is a demo alert dialog.'),
          //       Text('Would you like to approve of this message?'),
          //     ],
          //   ),
          // ),
          actions: <Widget>[
            RaisedButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> callback() async{
    if(messagecontroller.text.length == 0){
      _showMyDialog();
    }
    if(messagecontroller.text.length > 0) {
      await
      _firestore.collection('messages').document(widget.user.uid).collection(widget.receiverId).add({
        'text': messagecontroller.text,
        'from': widget.user.email,
        'user id': widget.user.uid,
        'receiver id': widget.receiverId,
        'receiver name': widget.receiverName,
        'message time': _timeString,
        'message length': '${messagecontroller.text.length}'
      });
      await
      _firestore.collection('messages').document(widget.receiverId).collection(widget.user.uid).add({
        'text': messagecontroller.text,
        'from': widget.user.email,
        'user id': widget.user.uid,
        'receiver id': widget.receiverId,
        'receiver name': widget.receiverName,
        'message time': _timeString,
        'message length': '${messagecontroller.text.length}'
      });
      messagecontroller.clear();
      scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return (widget.receiverId!=null && widget.user.uid!=null) ? Scaffold(
      // appBar:  AppBar(
      //   backgroundColor: Colors.lime,
      //
      //   leading: CircleAvatar(
      //     radius: 20.0,
      //     backgroundImage: widget.image != null ? NetworkImage(widget.image) : Image.asset("assets/images/dj4.jpg"),
      //   ),
      //   // Hero(
      //   //   tag: 'Logo',
      //   //   child:  Container(
      //   //     margin: EdgeInsets.only(left: 20.0),
      //   //     height: 35,
      //   //     child: Image.asset("assets/images/dj4.jpg"),
      //   //   ),
      //   // ),
      //   centerTitle: true,
      //   title: Text(widget.receiverName,style: TextStyle(color: Colors.brown),),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height*0.2,
            width: MediaQuery.of(context).size.width*1,
                decoration: new BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0), bottomRight: Radius.circular(50.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.4, 4.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height*0.25,
                      width: MediaQuery.of(context).size.width*0.25,
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.08),
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
                      alignment: Alignment.centerLeft,
                      child: new CircleAvatar(
                        radius: MediaQuery.of(context).size.width*0.12,
                        backgroundImage: widget.image != null ? NetworkImage(widget.image) : Image.asset("assets/images/dj4.jpg"),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.54,
                      height: MediaQuery.of(context).size.height*0.2,
                      alignment: Alignment.center,
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.04),
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02),
                        child: Text(widget.receiverName,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.055, fontWeight: FontWeight.bold),)
                    )
                  ]
                ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection("messages").document(widget.user.uid).collection(widget.receiverId).orderBy("message time", descending: false).snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return Center(child: CircularProgressIndicator(),);
                    }

                    List<DocumentSnapshot> docs = snapshot.data.documents;
                    size2 = snapshot.data.documents.length;

                    List<Widget> messages = docs.map((doc) => Message(
                      from: doc.data['from'],
                      text: doc.data['text'],
                      me: widget.user.email == doc.data['from'],
                      //userName: doc.data['user name'], 1111111111111111111111111111111111111111111111
                    )).toList();

                    return messages.length==0 ? Center(child: Text("No Message"),)
                        : ListView(
                            controller: scrollController,
                            children: <Widget>[
                              ...messages
                            ],
                          );
                  }
              )
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child:  Container(
                  height: MediaQuery.of(context).size.height*0.08,
                  margin: EdgeInsets.fromLTRB(5.0, 5.0, 1.0, 2.0),
                  child: TextField(
                    controller: messagecontroller,
                    decoration: InputDecoration(
                        hintText: "Enter a Message...",
                        border:  OutlineInputBorder(borderRadius: BorderRadius.circular(80.0))
                    ),
                    //onSubmitted: (value) => callback(),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: MediaQuery.of(context).size.height*0.08,
                child: IconButton(
                    color: Colors.blue,
                    alignment: Alignment.center,
                    icon: Icon(Icons.send, size: 35, ),
                    onPressed: callback
                ),
              )
              // SendButton(
              //   text: "send",
              //   callback: callback,
              // )
            ],
          )
        ],
      ),
    ) : Loading();
  }
}


// class SendButton extends StatelessWidget{
//
//   final String text;
//   final VoidCallback callback;
//
//   const SendButton({Key key, this.text, this.callback}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FlatButton(
//       color: Colors.orange,
//       onPressed: callback,
//       child:  Text(text),
//     );
//   }
//
// }


class Message extends StatelessWidget {

  final String from;
  final String text;
  // final String userName;

  final bool me;

  const Message({Key key, this.from, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   from,
          // ),

          // Card(
          //   color: me ? Colors.indigo : Colors.purple,
          //   margin:  me ? EdgeInsets.only(top: 6.0, bottom: 6.0, right: 0.0, left: MediaQuery.of(context).size.width*0.5) : EdgeInsets.only(top: 6.0, bottom: 6.0, left: 0.0, right: MediaQuery.of(context).size.width*0.5),
          //   elevation: 10.0,
          //   child: ListTile(
          //     title: Text(from, style: TextStyle(fontSize: 15.0, color: Colors.yellowAccent),),
          //     subtitle: Text(text, style: TextStyle(fontSize: 20.0, color: Colors.white),),
          //   ),
          // ),
          Container(
            margin: me ? EdgeInsets.only(left: MediaQuery.of(context).size.width*0.2, top: 6.0, bottom: 6.0, right: 2.0): EdgeInsets.only(right: MediaQuery.of(context).size.width*0.2, top: 6.0, bottom: 6.0, left: 2.0),
            child: Material(
              color:  me ? Colors.indigo : Colors.purple,
              borderRadius: BorderRadius.circular(10.0),
              elevation: 2.0,
              child: Container(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.028),
                child: Column(
                  children: <Widget>[
                    Text(text, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.055, color: Colors.white,),),
                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
