import 'dart:io';

import 'package:contact_buddy/models/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../provider/image_provider.dart';
import '../provider/user_contact_provider.dart';
import '../validators/input_validators.dart';
import '../validators/messages/snakbar_messages.dart';
import '../validators/utils/snackbar_utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailConatroller = TextEditingController();

  late final XFile? pickedFile;
  String updatedImagePath = '';

  // Function to pick image
  Future<void> getImage(BuildContext context, ImageSource source) async {
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      imageProvider.setImage(File(pickedFile.path));
      this.pickedFile = pickedFile;
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch user contact data when the page initializes
    Provider.of<UserContactProvider>(context, listen: false).fetchUserContact();
  }

  @override
  Widget build(BuildContext context) {
    final userContactProvider = Provider.of<UserContactProvider>(context);
    final imageProvider = Provider.of<ImagesProvider>(context);

    nameController.text = userContactProvider.userContact.name;
    phoneNumberController.text = userContactProvider.userContact.phoneNumber;
    emailConatroller.text = userContactProvider.userContact.eMail ?? '';
    String imagePath = userContactProvider.userContact.imagePath;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black54,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Profile',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.black12,
                backgroundImage: imageProvider.image != null
                    ? FileImage(imageProvider.image!)
                    : (imagePath.isNotEmpty
                        ? FileImage(File(imagePath))
                        : null),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    tooltip: 'Camera',
                    onPressed: () => getImage(context, ImageSource.camera),
                    icon: const Icon(Icons.camera_outlined),
                  ),
                  IconButton(
                    tooltip: 'Gallery',
                    onPressed: () => getImage(context, ImageSource.gallery),
                    icon: const Icon(Icons.image_outlined),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: SizedBox(
                  height: 45,
                  child: TextField(
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    controller: nameController,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black38,
                        ),
                      ),
                      labelText: 'name',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: SizedBox(
                  height: 45,
                  child: TextField(
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black38,
                        ),
                      ),
                      labelText: 'phone number',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: SizedBox(
                  height: 45,
                  child: TextField(
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    controller: emailConatroller,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black38,
                        ),
                      ),
                      labelText: 'email',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                width: 160,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // final DatabaseHelper dbHelper = DatabaseHelper();
                    // final contact = await dbHelper.getUserContact();
                    // log(contact!.eMail.toString());

                    final String name = nameController.text.trim();
                    final String phoneNumber =
                        phoneNumberController.text.trim();
                    final String email = emailConatroller.text.trim();
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
                          if (imageProvider.image != null) {
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
                          final Contact userContact = Contact(
                            name: name,
                            phoneNumber: phoneNumber,
                            eMail: email,
                            imagePath: imagePath,
                          );
                          // add or update data
                          if (context.mounted) {
                            final userContactProvider =
                                Provider.of<UserContactProvider>(context,
                                    listen: false);
                            await userContactProvider
                                .saveOrUpdateUserContact(userContact);
                            if (context.mounted) {
                              SnackbarUtils.showSnackbar(
                                  context,
                                  userContactProvider.isContactSaved
                                      ? SnackbarMessages.contactUpdated
                                      : SnackbarMessages.contactAdded);
                            }
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
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
