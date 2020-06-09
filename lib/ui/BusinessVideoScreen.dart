import 'package:flutter/material.dart';
import 'dart:io';
import 'package:thumbnails/thumbnails.dart';
import 'package:whatsappstatusdownloader/utils/Player.dart';

final Directory _videoDir =
    new Directory('/storage/emulated/0/WhatsApp Business/Media/.Statuses');

class BusinessVideoScreen extends StatefulWidget {
  @override
  BusinessVideoScreenState createState() => new BusinessVideoScreenState();
}

class BusinessVideoScreenState extends State<BusinessVideoScreen> {
  var videoList;
  _getImage(videoPathUrl) async {
    String thumb = await Thumbnails.getThumbnail(
        videoFile: videoPathUrl, imageType: ThumbFormat.PNG, quality: 10);
    return thumb;
  }

  @override
  void initState() {
    videoList = _videoDir
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".mp4"))
        .toList(growable: false);
    super.initState();
  }
  @override
  void dispose() {
   videoList=[];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Directory("${_videoDir.path}").existsSync()) {
      return Center(
        child: Text(
          "Install WhatsApp\nYour Friend's Status will be available here.",
          style: TextStyle(fontSize: 18.0),
        ),
      );
    } else {
      return Scaffold(
          body: videoList == null
              ? Container(child: Center(child: CircularProgressIndicator()))
              : videoList.length > 0
                  ? Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: GridView.builder(
                          itemCount: videoList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.0,
                            mainAxisSpacing: 10.0,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Player(videoFile: videoList[index]))
                                    // PlayStatus(videoList[index])),
                                    ),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    child: Container(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: FutureBuilder(
                                            future: _getImage(videoList[index]),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.hasData) {
                                                  return Hero(
                                                      tag: videoList[index],
                                                      child: Image.file(
                                                        File(snapshot.data),
                                                        fit: BoxFit.cover,
                                                      ));
                                                } else {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                              } else {
                                                return Hero(
                                                    tag: videoList[index],
                                                    child: Container(
                                                        height: 280.0,
                                                        child: Icon(
                                                          Icons.videocam,
                                                          color: Colors
                                                              .purple[300],
                                                          size: 40,
                                                        )));
                                              }
                                            }))));
                          }))
                  : Container(
                      child: Center(
                          child: Text(
                      "Sorry, No Videos Found.",
                      style: TextStyle(fontSize: 18.0),
                    ))));
    }
  }
}
