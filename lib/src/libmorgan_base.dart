import 'dart:async';
import 'dart:developer';
import 'dart:io';
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
    _encrypter = Encrypter(AES(_key!, mode: AESMode.cbc));
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

  void packImage(
      {required File imageFile,
      required Function(List<int> encryptedImage) onSuccess,
      void Function(int progress)? onProgress,
      void onError}) {
    List<int> buffer = [];

    buffer.addAll("ArthurMorgan".codeUnits);

    Image? image = decodeImage(imageFile.readAsBytesSync());
    Image thumbnail = copyResize(image!, width: 120);

    var thumbnailData = encodeJpg(thumbnail);

    buffer.addAll(encryptData(thumbnailData));
    buffer.addAll(List.filled(65536 - buffer.length, 0));
    buffer.addAll(encryptData(imageFile.readAsBytesSync()));

    onSuccess(buffer);
    return;
  }

  void unpackImage(File imageFile) {
    List<int> imageData = imageFile.readAsBytesSync();
    var thumbnail = imageData.getRange(12, 65536).toList();
    var image = imageData.getRange(65536, imageData.length).toList();
    File("thumbnail.jpeg").writeAsBytesSync(thumbnail);
    File("image.jpeg").writeAsBytesSync(image);
  }
}
