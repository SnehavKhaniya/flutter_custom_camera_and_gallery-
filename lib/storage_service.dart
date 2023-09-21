
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService{
  final storage = FirebaseStorage.instance;

  Future<void> uploadFile(
      String filePath,
      String fileName,
      ) async{
    File file = File(filePath);

    try{
      await storage.ref('images/$fileName').putFile(file);
    }
    catch(e){
      print("error: ${e}");
    }
  }

  Future<ListResult> listFiles() async{
    ListResult results = await storage.ref('images').listAll();
    return results;
  }

}

