import 'dart:developer';
import 'dart:io';

import 'package:libmorgan/libmorgan.dart';

void main() {
  Morgan morgan = Morgan("password", 16);
  bool isInit = morgan.init("xK4j7I3pqi55x8qIASNqzQ==");

  // var data = morgan
  //     .packImage(File("D:/GitHub/arthurmorgan/libmorgan/example/hehe.png"));

  // File("dump.hex").writeAsBytesSync(data);

  // var data =
  //     morgan.getThumbnail(File("D:/GitHub/arthurmorgan/libmorgan/dump.hex"));
  // File("dump.jpeg").writeAsBytesSync(data);

  // log("here");
}
