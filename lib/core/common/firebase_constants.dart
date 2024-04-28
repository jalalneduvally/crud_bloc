import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Constants {
  static const product ="products";
  static const category ="catalog";
  static const user ="users";
}
void showMessage(BuildContext context,{required String text,required Color color}){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: color,
          content: Text(text))
  );
}
// Future pickImage() async {
//   final imageFile=await ImagePicker.platform.pickImage(source: ImageSource.gallery);
//   return imageFile;
// }

Future<String> storeFile({
  required String path,
  required File? file
})async{
  try{
    final ref=FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask=ref.putFile(file!);
    final snapshot =await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }catch(e){
    throw Exception(e);
  }
}
