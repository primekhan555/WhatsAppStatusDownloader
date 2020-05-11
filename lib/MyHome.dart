import 'package:flutter/material.dart';
import 'ui/ImageScreen.dart';
import 'ui/VideoScreen.dart';

class MyHome extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Status Downloader'),
            backgroundColor: Colors.purple[300],
            bottom: TabBar(
                unselectedLabelStyle: TextStyle(
                  fontSize: 12,
                ),
                tabs: [
                  Tab(
                    text: "VIDEOS",
                  ),
                  Tab(
                    text: "IMAGES",
                  ),
                ]),
          ),
          body: TabBarView(
            children: [
              VideoScreen(),
              ImageScreen(),
              
            ],
          ),
        ));
  }
}
