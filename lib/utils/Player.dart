import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsappstatusdownloader/GlobalState.dart';

class Player extends StatefulWidget {
  final String videoFile;
  Player({Key key, this.videoFile}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  VideoPlayerController _videoController;
  bool play = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Future<bool> init() async {
    _videoController = VideoPlayerController.file(File(widget.videoFile));
    await _videoController.initialize();
    await _videoController.play();
    return true;
  }

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.white,
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Container(
          child: Stack(
            children: <Widget>[
              FutureBuilder<bool>(
                future: init(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1.5 / 2,
                          child: VideoPlayer(_videoController),
                        ),
                        _PlayPauseOverlay(videoController: _videoController),
                      ],
                      // ),
                    );
                  } else {
                    return Center(
                      child: Container(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.purple[300],
          child: Icon(Icons.storage),
          onPressed: () async {
            _onLoading(true);
            File originalVideoFile = File(widget.videoFile);
            List<String> list = originalVideoFile.path.toString().split("/");
            // Directory directory = await getExternalStorageDirectory();
            if (!Directory(
                    "/storage/emulated/0/whatsappstatusdownloader/Videos")
                .existsSync()) {
              Directory("/storage/emulated/0/whatsappstatusdownloader/Videos")
                  .createSync(recursive: true);
            }
            String name = list[list.length - 1];
            String newName =
                "/storage/emulated/0/whatsappstatusdownloader/Videos/'$name'.mp4";
            await originalVideoFile.copy(newName);

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

class _PlayPauseOverlay extends StatelessWidget {
  _PlayPauseOverlay({Key key, this.videoController}) : super(key: key);

  final VideoPlayerController videoController;

  @override
  Widget build(BuildContext context) {
    final GlobalState globalstate = Provider.of<GlobalState>(context);
    return Container(
      padding: EdgeInsets.only(top: 10),
      height: 80,
      child: Column(
        children: <Widget>[
          VideoProgressIndicator(
            videoController,
            allowScrubbing: true,
            padding: EdgeInsets.only(left: 20, right: 20),
            colors: VideoProgressColors(playedColor: Colors.purple[300]),
          ),
          IconButton(
              icon: Icon(
                globalstate.getPlay == "play" ? Icons.pause : Icons.play_arrow,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () {
                if (globalstate.getPlay == "play") {
                  globalstate.setPlay("pause");
                  videoController.pause();
                } else {
                  globalstate.setPlay("play");
                  videoController.play();
                }
              }),
        ],
      ),
    );
  }
}
