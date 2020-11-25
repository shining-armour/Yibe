import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MediaService {
  static MediaService instance = MediaService();
  final _picker = ImagePicker();

  Future<File> getCamImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

  Future<File> getGalleryImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

}