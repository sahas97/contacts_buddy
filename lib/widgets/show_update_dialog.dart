import 'dart:io';

import 'package:contact_buddy/provider/image_provider.dart';
import 'package:contact_buddy/validators/utils/snackbar_utils.dart';
import 'package:contact_buddy/validators/messages/snakbar_messages.dart';
import 'package:flutter/material.dart';
import 'package:contact_buddy/models/contacts_model.dart';
import 'package:contact_buddy/validators/input_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

/// The ContactDialog class provides a method to show a dialog for updating a contact's information.
class UpdateContactDialog {
  static void showUpdateDialog(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController phoneNumberController,
    TextEditingController emailController,
    Contact existingContact,
    Function(Contact) onUpdate,
  ) {
    TextEditingController updatedNameController =
        TextEditingController.fromValue(nameController.value);
    TextEditingController updatedPhoneNumberController =
        TextEditingController.fromValue(phoneNumberController.value);
    TextEditingController updatedEmailController =
        TextEditingController.fromValue(emailController.value);

    updatedNameController.text = existingContact.name;
    updatedPhoneNumberController.text = existingContact.phoneNumber;
    updatedEmailController.text = existingContact.eMail!;
    String imagePath = existingContact.imagePath;

    final ImagesProvider imagesProvider =
        Provider.of<ImagesProvider>(context, listen: false);
    late XFile? pickedFile;
    String updatedImagePath = '';

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
                alignment: Alignment.center,
                title: const Center(child: Text('Update Contact')),
                contentPadding: const EdgeInsets.all(20.0),
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black12,
                      backgroundImage: imagesProvider.image != null
                          ? FileImage(imagesProvider.image!)
                          : (imagePath.isNotEmpty
                              ? FileImage(File(imagePath))
                              : null),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => getImage(ImageSource.camera),
                        icon: const Icon(Icons.camera),
                      ),
                      IconButton(
                        onPressed: () => getImage(ImageSource.gallery),
                        icon: const Icon(Icons.image),
                      )
                    ],
                  ),
                  TextField(
                    controller: updatedNameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: updatedPhoneNumberController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                  ),
                  TextField(
                    controller: updatedEmailController,
                    decoration: const InputDecoration(labelText: 'email'),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SimpleDialogOption(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'UPDATE',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// The `onPressed` function is the callback function that is executed when the "UPDATE"
                    /// button is pressed in the dialog.
                    onPressed: () async {
                      final String updatedName =
                          updatedNameController.text.trim();
                      final String updatedPhoneNumber =
                          updatedPhoneNumberController.text.trim();
                      final String updatedEmail =
                          updatedEmailController.text.trim();

                      if (InputValidators.isNotEmpty(updatedName) &&
                          InputValidators.isNotEmpty(updatedPhoneNumber)) {
                        if (InputValidators.isValidPhoneNumber(
                            updatedPhoneNumber)) {
                          if (InputValidators.isNotEmpty(updatedEmail) &&
                              !InputValidators.isValidEmail(updatedEmail)) {
                            SnackbarUtils.showSnackbar(
                                context, SnackbarMessages.invalidEmail);
                          } else {
                            if (imagesProvider.image != null) {
                              final Directory directory =
                                  await getApplicationDocumentsDirectory();
                              final String newPath =
                                  '${directory.path}/app_images';
                              await Directory(newPath).create(recursive: true);
                              final String newFilePath =
                                  '$newPath/${DateTime.now().millisecondsSinceEpoch}.png';
                              await File(pickedFile!.path).copy(newFilePath);
                              updatedImagePath = newFilePath;
                            } else {
                              updatedImagePath = imagePath;
                            }
                            final Contact updatedContact = Contact(
                              id: existingContact.id,
                              name: updatedName,
                              phoneNumber: updatedPhoneNumber,
                              eMail: updatedEmail,
                              imagePath: updatedImagePath,
                            );
                            onUpdate(updatedContact);
                            if (context.mounted) Navigator.pop(context);
                            if (context.mounted) {
                              SnackbarUtils.showSnackbar(
                                  context, SnackbarMessages.contactUpdated);
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
        });
  }
}
