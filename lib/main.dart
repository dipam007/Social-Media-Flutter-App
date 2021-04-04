import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/admin.dart';
import 'package:social_media_app/check_internet_connectivity/checkInternetConnectivity.dart';
import 'package:social_media_app/dashboard.dart';
import 'package:social_media_app/signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    WidgetsFlutterBinding.ensureInitialized();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyMainPage()
    );
  }
}

class MyMainPage extends StatefulWidget {
  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {

  String userId;

  void initState(){
    InternetConnectivity(context: context).checkInternetConnectivity();
    super.initState();
    checkingLogOutOrNot();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkingLogOutOrNot() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('uid');
    });
  }
  @override
  Widget build(BuildContext context){
    return userId == null ? SignIn(): (userId == 'ecQwKcoiejhZ8LKL3WB63YdCGhy2' ? AdminPage() :DashBoard(uid: userId,));
  }
}


