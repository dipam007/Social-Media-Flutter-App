import 'package:flutter/material.dart';
import 'package:social_media_app/check_internet_connectivity/checkInternetConnectivity.dart';
import 'package:social_media_app/dashboard.dart';
import 'file:///C:/Users/aa/AndroidStudioProjects/social_media_app/lib/Services/database.dart';
import 'package:social_media_app/loading.dart';
import 'package:social_media_app/settings_form.dart';
import 'file:///C:/Users/aa/AndroidStudioProjects/social_media_app/lib/Services/user.dart';
import 'package:social_media_app/profile.dart';


class DrawerPage extends StatefulWidget {

  final String uid;
  DrawerPage({this.uid});
  @override
  _DrawerPageState createState() => _DrawerPageState(uid: uid);
}

class _DrawerPageState extends State<DrawerPage> {

  final String uid;
  _DrawerPageState({this.uid});

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
      return StreamBuilder<UserData>(
              stream: DatabaseService(uid: uid).userData,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Loading();
                }
                else {
                  UserData userData = snapshot.data;
                  return Container(
                    child: Drawer(
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              UserAccountsDrawerHeader(
                                accountName: Text(userData.name),
                                accountEmail: Text("${userData.email}"),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/back4.jpg"),
                                      fit: BoxFit.cover,
                                    )
                                ),
                                currentAccountPicture: CircleAvatar(
                                  child: Text(userData.name[0].toUpperCase(),
                                    style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w500, color: Colors.white),
                                  ),
                                  backgroundColor: Colors.black45,
                                ),
                                // onDetailsPressed: () {},
                              ),
                              ListTile(
                                leading: Icon(Icons.home, size: 25,color: Colors.brown,),
                                title: Text("DashBoard", style: TextStyle(fontSize: 22.0, color:Colors.blueGrey, letterSpacing: 1.0, fontWeight: FontWeight.w500),),
                                enabled: true,
                                trailing: Icon(Icons.dashboard, size: 25,color:  Colors.brown[400],),
                                //is shows the icon in right side or end
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DashBoard(uid: uid,)
                                  ));
                                },
                              ),
                              Divider(height: 4,),
                              ListTile(
                                leading: Icon(Icons.account_circle, size: 25,color: Colors.green,),
                                title: Text("Profile", style: TextStyle(fontSize: 22.0, color:Colors.blueGrey, letterSpacing: 1.0, fontWeight: FontWeight.w500),),
                                enabled: true,
                                trailing: Icon(Icons.account_box, size: 25,color:  Colors.green,),
                                //is shows the icon in right side or end
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Profile(uid: uid,userName: userData.name,)
                                  ));
                                },
                              ),
                              Divider(height: 4,),
                              ListTile(
                                  leading: Icon(Icons.chat, size: 25,color: Colors.blue,),
                                  title: Text("Chat", style: TextStyle(fontSize: 22.0, color:Colors.blueGrey, letterSpacing: 1.0, fontWeight: FontWeight.w500),),
                                  trailing: Icon(Icons.message,size: 25,color: Colors.blue,),
                                  //is shows the icon in right side or end
                                  onTap: ()  {}
                              ),
                              Divider(height: 4,),
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: ListTile(
                                          leading: Icon(Icons.settings, size: 25),
                                          trailing: Icon(Icons.settings_applications, size: 25),
                                          title: Text("Settings", style: TextStyle(fontSize: 22.0, color:Colors.blueGrey, letterSpacing: 1.0, fontWeight: FontWeight.w600),),
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsForm(uid: uid,)));
                                          }
                                      )
                                  )
                              ),
                            ]
                        )
                    ),
                  );
                }
              }
      );
  }
}
