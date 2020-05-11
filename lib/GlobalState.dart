import 'package:flutter/foundation.dart';

class GlobalState with ChangeNotifier {
  String _play = "play";
  bool videoControllerOpacity = true;

  String get getPlay => _play;

  void setPlay(String value) {
    if (value=="play") {
      _play = "play";
    } else {
      _play = "pause";
    }
    notifyListeners();
  }
  bool get getvideoControllerOpacity=>videoControllerOpacity;

  void setOpacity() {
    if (videoControllerOpacity) {
      videoControllerOpacity = false;
    } else {
      videoControllerOpacity = true;
    }
  }
}
