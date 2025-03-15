import 'package:rive/rive.dart';

class RiveAsset {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAsset(
      {required this.src,
      required this.artboard,
      required this.stateMachineName,
      required this.title,
      this.input});

  set setInputStatus(SMIBool status) {
    input = status;
  }
}


