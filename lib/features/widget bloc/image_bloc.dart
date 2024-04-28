import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/image_picker_utils.dart';


abstract class ImagePickerEvent extends Equatable{
  const ImagePickerEvent();
  @override
  List<Object?> get props =>[];
}

class CameraCapture extends ImagePickerEvent{}
class GalleryImagePicker extends ImagePickerEvent{}
class GalleryImagePickerExited extends ImagePickerEvent{}

class ImagePickerState extends Equatable{
  final XFile? file;
  const ImagePickerState({this.file});

  ImagePickerState copyWith({XFile? file}){
    return ImagePickerState(
    file: file ??this.file
    );
}

  @override
  // TODO: implement props
  List<Object?> get props => [file];
}

class ImagePickerBloc extends Bloc<ImagePickerEvent,ImagePickerState>{
  final ImagePickerUtils imagePickerUtils;
  ImagePickerBloc(this.imagePickerUtils):super(const ImagePickerState()){

    on<GalleryImagePicker>(galleryImagePicker);

    on<GalleryImagePickerExited>((event, emit) {
      emit(const ImagePickerState(file: null));
    });
  }
  void galleryImagePicker(GalleryImagePicker event, Emitter<ImagePickerState> states)async{
    XFile? file = await imagePickerUtils.pickImageFromGallery();
    emit(state.copyWith(file: file));
  }

}

