import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'MyHome.dart';
import 'package:whatsappstatusdownloader/GlobalState.dart';



void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    if (status == PermissionStatus.denied) {
      await permission.request();
    }
    if (status == PermissionStatus.granted) {
     var route= MaterialPageRoute(builder: (context)=>MyHome());
      Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route)=>false);
    }
  }
  

  @override
  void initState() {
    requestPermission(Permission.storage);
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Icon(Icons.videocam,size: 45,color: Colors.purple[300],),
        ),
      ),
    );
  }
}
