import 'package:image_picker/image_picker.dart';

class PickImage {
  static Future<XFile?> pickFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1600,
      maxWidth: 1600,
    );
    return image;
  }

  static Future<XFile?> pickFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1600,
      maxWidth: 1600,
    );
    return image;
  }

  static Future<List<XFile>?> pickFromGalleryMulti() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage(
      maxHeight: 1600,
      maxWidth: 1600,
    );
    return images;
  }
}
