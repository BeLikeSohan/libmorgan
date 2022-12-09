import 'dart:developer';
import 'dart:io';

import 'package:libmorgan/libmorgan.dart';

void main() {
  Morgan morgan = Morgan("password", 16);
  bool isInit = morgan.init("xK4j7I3pqi55x8qIASNqzQ==");

  log(isInit.toString());

  morgan.packImage(
      imageFile:
          File("C:/Users/belik/Documents/GitHub/libmorgan/example/hehe.png"),
      onSuccess: (i) {
        File("data.hex").writeAsBytesSync(i);
      },
      onProgress: (i) {});

  log("here");
}
