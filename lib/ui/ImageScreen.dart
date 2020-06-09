import 'package:flutter/material.dart';
import 'dart:io';
import 'package:whatsappstatusdownloader/ui/ViewPhotos.dart';

final Directory _photoDir =
    new Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

class ImageScreen extends StatefulWidget {
  @override
  ImageScreenState createState() => new ImageScreenState();
}

class ImageScreenState extends State<ImageScreen> {
  var imageList;
  @override
  void initState() {
    imageList = _photoDir
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".jpg"))
        .toList(growable: false);
    super.initState();
  }
  @override
  void dispose() {
    imageList=[];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Directory("${_photoDir.path}").existsSync()) {
      return Center(
        child: Text(
          "Install WhatsApp\nYour Friend's Status Will Be Available Here",
          style: TextStyle(fontSize: 18.0),
        ),
      );
    } else {
      if (imageList.length > 0) {
        return Container(
            margin: EdgeInsets.all(8.0),
            child: GridView.builder(
                itemCount: imageList.length-15,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 10.0),
                itemBuilder: (context, index) {
                  String imgPath = imageList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new ViewPhotos(imgPath)));
                    },
                    child: Hero(
                        tag: imgPath,
                        child: Container(
                          padding: EdgeInsets.only(left: 3, right: 3),
                          child: Image.file(
                            File(imgPath),
                            fit: BoxFit.cover,
                          ),
                        )),
                  );
                }));
      } else {
        return Scaffold(
          body: Center(
            child: new Container(
                padding: EdgeInsets.only(bottom: 60.0),
                child: Text(
                  'Sorry, No Image Found!',
                  style: TextStyle(fontSize: 18.0),
                )),
          ),
        );
      }
    }
  }
}
