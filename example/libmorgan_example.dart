// import 'dart:developer';
// import 'dart:io';
// import 'dart:isolate';

// import 'package:libmorgan/libmorgan.dart';

// void main() async {
//   Morgan morgan = Morgan("password", 16);
//   bool isInit = morgan.init("xK4j7I3pqi55x8qIASNqzQ==");

//   print("START");

//   // var data = morgan
//   //     .packVideo(File("D:/GitHub/arthurmorgan/libmorgan/example/test.mp4"));

//   ReceivePort receiverPort = ReceivePort();

//   Isolate.spawn<SendPort>(
//     morgan.packVideo,
//     receiverPort.sendPort,
//   );

//   print("CONTINUE");

//   receiverPort.listen((message) {
//     print(message.toString());
//     if (message == "packVideo_DONE") exit(0);
//   });

//   // morgan
//   //     .unpackVideo(File("D:/GitHub/arthurmorgan/libmorgan/temp_encrypted.hex"));

//   // File("dump.hex").writeAsBytesSync(data);

//   // var data =
//   //     morgan.getThumbnail(File("D:/GitHub/arthurmorgan/libmorgan/dump.hex"));
//   // File("dump.jpeg").writeAsBytesSync(data);

//   // log("here");
// }
