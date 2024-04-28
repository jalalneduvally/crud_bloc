import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  final ImagePicker _picker=ImagePicker();

  Future cameraCapture()async{
    final  file = await _picker.pickImage(source: ImageSource.camera);
    return file;
  }
  Future pickImageFromGallery()async{
    final  file = await _picker.pickImage(source: ImageSource.gallery);
    return file;
  }

}