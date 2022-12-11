import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:image/image.dart';
import 'package:libmorgan/src/utils.dart';

class Morgan {
  Encrypter? _encrypter;
  Key? _key;
  IV? _iv;
  bool _isInitSuccess = false;

  Morgan(String password, int iv) {
    _key = Key.fromUtf8(Utils.padPassToKey(password));
    _iv = IV.fromLength(iv);
    _encrypter = Encrypter(AES(_key!, mode: AESMode.ctr, padding: null));
  }

  bool init(String verifyString) {
    if (_encrypter!.encrypt("ArthurMorgan", iv: _iv).base64 == verifyString) {
      _isInitSuccess = true;
      return true;
    } else {
      return false;
    }
  }

  String genVerifyString() {
    return _encrypter!.encrypt("ArthurMorgan", iv: _iv).base64;
  }

  List<int> encryptData(List<int> data) {
    return _encrypter!.encryptBytes(data, iv: _iv).bytes;
  }

  List<int> decryptData(List<int> data) {
    return _encrypter!
        .decryptBytes(Encrypted(Uint8List.fromList(data)), iv: _iv);
  }

  String encryptFileName(String fileName) {
    return _encrypter!.encrypt(fileName, iv: _iv).base64;
  }

  String decryptFileName(String fileName) {
    return _encrypter!.decrypt(Encrypted.fromBase64(fileName), iv: _iv);
  }

  List<int> packImage(File imageFile) {
    List<int> buffer = [];

    buffer.addAll("ArthurMorgan".codeUnits);

    Image? image = decodeImage(imageFile.readAsBytesSync());
    Image thumbnail = copyResize(image!, width: 120);

    List<int> thumbnailData = encodeJpg(thumbnail);
    List<int> encryptedThumbnailData = encryptData(thumbnailData);

    buffer.addAll(
        encryptedThumbnailData.length.toString().padLeft(12, '0').codeUnits);

    buffer.addAll(encryptedThumbnailData);
    buffer.addAll(List.filled(65536 - buffer.length, 0));
    buffer.addAll(encryptData(imageFile.readAsBytesSync()));

    log(thumbnailData.length.toString());
    log(encryptData(thumbnailData).length.toString());

    return buffer;
  }

  void packVideo(Map<dynamic, dynamic> data) async {
    File videoFile = data["videoFile"];
    var tempFile = data["tempFile"];
    SendPort port = data["port"];

    double lenWritten = 0;
    int fileLen = videoFile.lengthSync();

    var fileStream = videoFile.openRead();

    print(tempFile.path.toString());
    tempFile.writeAsBytes("ArthurMorgan".codeUnits);
    fileStream.listen((data) {
      //xData.addAll(List.filled(65536 - data.length, 0));
      print(data.length.toString());
      var enc = encryptData(data);
      lenWritten += data.length;
      tempFile.writeAsBytesSync(encryptData(data), mode: FileMode.append);
      double response = (lenWritten / fileLen) * 100;
      port.send(response);
    }, onDone: () {
      Isolate.exit(port, "PACK_VIDEO_DONE");
    });
  }

  void unpackVideo(Map<dynamic, dynamic> data) async {
    File videoFile = data["videoFile"];
    var saveFile = data["saveFile"];
    SendPort port = data["port"];

    double lenWritten = 0;
    int fileLen = videoFile.lengthSync();

    var fileStream = videoFile.openRead();

    print(saveFile.path.toString());
    fileStream.listen((data) {
      var enc = decryptData(data);
      lenWritten += data.length;
      saveFile.writeAsBytesSync(encryptData(data), mode: FileMode.append);
      double response = (lenWritten / fileLen) * 100;
      port.send(response);
    }, onDone: () {
      Isolate.exit(port, "UNPACK_VIDEO_DONE");
    });
  }

  List<int> getThumbnail(Uint8List imageData) {
    var thumbnailLength =
        int.parse(String.fromCharCodes(imageData.getRange(12, 24)));
    log(thumbnailLength.toString());

    var thumbnailEncrypted =
        imageData.getRange(24, 24 + thumbnailLength).toList();
    var thumbnail = decryptData(thumbnailEncrypted);
    return thumbnail;
  }
}
