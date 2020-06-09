import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:gallery_saver/gallery_saver.dart';

class ViewPhotos extends StatefulWidget {
  final String imgPath;
  ViewPhotos(this.imgPath);
  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void _onLoading(bool t) {
    if (t) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                Center(
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator()),
                ),
              ],
            );
          });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black12,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.indigo,
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: widget.imgPath,
                child: Image.file(
                  File(widget.imgPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple[300],
          child: Icon(Icons.storage),
          onPressed: () async {
            _onLoading(true);
            Uri myUri = Uri.parse(widget.imgPath);
            // print("this is the path${myUri.path}");
            // String path=myUri.path.toString();
            // GallerySaver.saveImage(path).then((value) {
            //   print("image saved $value" );
            // });
            
            File originalImageFile = new File.fromUri(myUri);
            Uint8List bytes;
            await originalImageFile.readAsBytes().then((value) {
              bytes = Uint8List.fromList(value);
            }).catchError((onError) {
              print('Exception Error while reading audio from path:' +
                  onError.toString());
            });
            await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));
            _onLoading(false);
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              duration: Duration(milliseconds: 500),
                content: RichText(
                    text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: "Saved, ",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              TextSpan(
                  text: "If not in Gallary\nFind all images at ",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              TextSpan(
                  text: "FileManager > whatsappstatusdownloader",
                  style: TextStyle(color: Colors.teal))
            ]))));
          }),
    );
  }
}
