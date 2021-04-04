import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class InternetConnectivity{
  BuildContext context;
  InternetConnectivity({this.context});

  showDialogBox(title, text){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              OutlinedButton(
                  child: Text("OK"),
                  onPressed: (){
                    Navigator.of(context).pop();
                    checkInternetConnectivity();
                  }
              )
            ],
          );
        }
    );
  }

 checkInternetConnectivity() async{
  var result = await Connectivity().checkConnectivity();
  if(result == ConnectivityResult.none){
    showDialogBox("No Internet", "You are not connected to Network!!!");
  }
  else if(result == ConnectivityResult.mobile){
    // showDialogBox("Internet Access", "You are connected to Network over Mobile Network");
  }
  else if(result == ConnectivityResult.wifi){
    // showDialogBox("Internet Access", "You are connected to Network over WiFi");
  }
}
}