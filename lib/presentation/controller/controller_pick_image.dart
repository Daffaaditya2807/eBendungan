import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ControllerPickImage extends GetxController {
  Future<void> pickImage(ImageSource source, CroppedFile croppedFile) async {
    final pickedImage = await pickedFileImage(source);
    if (pickedImage != null) {
      CroppedFile? cropFile = await cropImage(pickedImage);
      if (cropFile != null) {
        croppedFile = cropFile;
      }
    }
  }

  Future<XFile?> pickedFileImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        return pickedFile;
      } else {
        return null;
      }
    } catch (e) {
      print("Terjadi kesalahan saat memilih gambar : $e");
      return null;
    }
  }

  Future<CroppedFile?> cropImage(XFile image) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Sesuaikan Gambar',
            toolbarColor: Colors.blueAccent,
            toolbarWidgetColor: Colors.white,
            cropFrameColor: Colors.greenAccent,
            hideBottomControls: false,
            activeControlsWidgetColor: Colors.blue,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    );
    return croppedFile;
  }
}
