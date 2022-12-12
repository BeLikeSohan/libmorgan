import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:libmorgan/libmorgan.dart';

void main() async {
  Morgan morgan = Morgan("password", 16);
  bool isInit = morgan.init("xK4j7I3pqi55x8qIASNqzQ==");

  print("START");

  // var data = morgan
  //     .packVideo(File("D:/GitHub/arthurmorgan/libmorgan/example/test.mp4"));

  ReceivePort receiverPort = ReceivePort();

  // Isolate.spawn(morgan.packVideo, {
  //   "videoFile": File("D:/GitHub/arthurmorgan/libmorgan/example/test.mp4"),
  //   "tempFile": File("temp.hex"),
  //   "port": receiverPort.sendPort,
  // });

  // Isolate.spawn(morgan.unpackVideo, {
  //   "tempFile": File("D:/GitHub/arthurmorgan/libmorgan/example/temp.hex"),
  //   "saveFile": File("save.mp4"),
  //   "port": receiverPort.sendPort,
  // });

  // Isolate.spawn(morgan.packImage, {
  //   "imageFile": File("D:/GitHub/arthurmorgan/libmorgan/example/hehe.png"),
  //   "tempFile": File("temp.hex"),
  //   "port": receiverPort.sendPort,
  // });

  Isolate.spawn(morgan.unpackImage, {
    "tempFile": File("D:/GitHub/arthurmorgan/libmorgan/example/temp.hex"),
    "saveFile": File("temp.png"),
    "port": receiverPort.sendPort,
  });

  print("CONTINUE");

  receiverPort.listen((message) {
    print(message.toString());
  });

  // morgan
  //     .unpackVideo(File("D:/GitHub/arthurmorgan/libmorgan/temp_encrypted.hex"));

  // File("dump.hex").writeAsBytesSync(data);

  // var data =
  //     morgan.getThumbnail(File("D:/GitHub/arthurmorgan/libmorgan/dump.hex"));
  // File("dump.jpeg").writeAsBytesSync(data);

  // log("here");
}
