import 'dart:io';
import 'package:contact_buddy/provider/image_provider.dart';
import 'package:contact_buddy/validators/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ContactDialogUtils {
  static Future<void> pickImage(BuildContext context,
      ImagesProvider imagesProvider, ImageSource source) async {
    late XFile? pickedFile;
    pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      imagesProvider.setImage(File(pickedFile.path));
    }
  }

  static Future<String> saveImageToAppDirectory(File? pickedFile) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String newPath = '${directory.path}/app_images';
    await Directory(newPath).create(recursive: true);
    final String newFilePath =
        '$newPath/${DateTime.now().millisecondsSinceEpoch}.png';
    await File(pickedFile!.path).copy(newFilePath);
    return newPath;
  }

  static void showSnackbarAndPop(BuildContext context, String message) {
    Navigator.pop(context);
    SnackbarUtils.showSnackbar(context, message);
  }

  static void clearControllersAndImage(
      ImagesProvider imagesProvider,
      TextEditingController nameController,
      TextEditingController phoneNumberController) {
    imagesProvider.clearImage();
    nameController.clear();
    phoneNumberController.clear();
  }
}
