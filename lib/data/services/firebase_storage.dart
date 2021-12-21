import 'dart:io';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseStorage {
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<String?> uploadFile(
      {required String fileName, required String localFilePath, required String cloudPath}) async {
    File file = File(localFilePath);
    try {
      await storage.ref('$cloudPath/$fileName').putFile(file);
      return await storage.ref('$cloudPath/$fileName').getDownloadURL();
    } on firebase_core.FirebaseException catch (e) {
      return null;
    }
  }
}
