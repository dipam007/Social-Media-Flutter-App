import 'package:flutter/material.dart';
import 'package:social_media_app/check_internet_connectivity/checkInternetConnectivity.dart';
import 'package:social_media_app/dashboard.dart';

class HomeTabBar extends StatefulWidget {
  @override
  _HomeTabBarState createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> {

  List<Widget> tabBarScreens = [
    Container(color: Colors.brown[200],),
    Container(color: Colors.lightGreenAccent,),
    Container(color: Colors.lightBlue,),
    Container(color: Colors.redAccent,),
  ];

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
    return DefaultTabController(
      length: 4,
      child: new Scaffold(
        appBar: new AppBar(
          bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: "Home",
                ),
                Tab(
                  text: "Chat",
                ),
                Tab(
                  text: "Search",
                ),
                Tab(
                  text: "Profile",
                ),
              ]
          ),
        ),
        body: TabBarView(
            children: tabBarScreens
        ),
      ),
    );
  }
}
