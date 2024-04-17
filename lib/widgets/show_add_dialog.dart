import 'dart:io';
import 'package:contact_buddy/provider/image_provider.dart';
import 'package:contact_buddy/validators/utils/snackbar_utils.dart';
import 'package:contact_buddy/validators/messages/snakbar_messages.dart';
import 'package:flutter/material.dart';
import 'package:contact_buddy/models/contacts_model.dart';
import 'package:contact_buddy/validators/input_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AddContactDialog {
  static void showAddDialog(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController phoneNumberController,
    TextEditingController emailController,
    Function(Contact) onAdd,
  ) {
    final ImagesProvider imagesProvider =
        Provider.of<ImagesProvider>(context, listen: false);
    late XFile? pickedFile;

    // Function to pick image
    Future<void> getImage(ImageSource source) async {
      pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        imagesProvider.setImage(File(pickedFile!.path));
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ImagesProvider>(
          builder: (context, imagesProvider, child) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.white,
              alignment: Alignment.center,
              title: Center(
                child: Text(
                  'Add New Contact',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.all(30.0),
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.black12,
                    backgroundImage: imagesProvider.image != null
                        ? FileImage(imagesProvider.image!)
                        : null,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => getImage(ImageSource.camera),
                      icon: const Icon(
                        Icons.camera_outlined,
                      ),
                    ),
                    IconButton(
                      onPressed: () => getImage(ImageSource.gallery),
                      icon: const Icon(
                        Icons.image_outlined,
                      ),
                    )
                  ],
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'E mail',
                    labelStyle: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SimpleDialogOption(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    final String name = nameController.text.trim();
                    final String phoneNumber =
                        phoneNumberController.text.trim();
                    final String email = emailController.text.trim();
                    if (InputValidators.isNotEmpty(name) &&
                        InputValidators.isNotEmpty(phoneNumber)) {
                      if (InputValidators.isValidPhoneNumber(phoneNumber)) {
                        if (InputValidators.isNotEmpty(email) &&
                            !InputValidators.isValidEmail(email)) {
                          SnackbarUtils.showSnackbar(
                              context, SnackbarMessages.invalidEmail);
                          return;
                        } else {
                          String imagePath = '';
                          if (imagesProvider.image != null) {
                            final Directory directory =
                                await getApplicationDocumentsDirectory();
                            final String newPath =
                                '${directory.path}/app_images';
                            await Directory(newPath).create(recursive: true);
                            final String newFilePath =
                                '$newPath/${DateTime.now().millisecondsSinceEpoch}.png';
                            await File(pickedFile!.path).copy(newFilePath);
                            imagePath = newFilePath;
                          }
                          final Contact newContact = Contact(
                            name: name,
                            phoneNumber: phoneNumber,
                            eMail: email,
                            imagePath: imagePath,
                          );
                          onAdd(newContact);
                          imagesProvider.clearImage();
                          nameController.clear();
                          phoneNumberController.clear();
                          emailController.clear();

                          if (context.mounted) {
                            if (context.mounted) Navigator.pop(context);
                            SnackbarUtils.showSnackbar(
                                context, SnackbarMessages.contactAdded);
                          }
                        }
                      } else {
                        SnackbarUtils.showSnackbar(
                            context, SnackbarMessages.invalidNumber);
                      }
                    } else {
                      SnackbarUtils.showSnackbar(
                          context, SnackbarMessages.invalidInput);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
