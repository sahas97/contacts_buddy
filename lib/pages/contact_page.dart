import 'dart:io';
import 'dart:math';
import 'package:contact_buddy/models/contacts_model.dart';
import 'package:contact_buddy/provider/contacts_provider.dart';
import 'package:contact_buddy/validators/utils/snackbar_utils.dart';
import 'package:contact_buddy/validators/messages/snakbar_messages.dart';
import 'package:contact_buddy/widgets/fading_text.dart';
import 'package:contact_buddy/widgets/show_update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  late ContactsProvider _contactsProvider;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailConatoller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contactsProvider = context.read<ContactsProvider>();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    await _contactsProvider.fetchContacts();
  }

  Future<void> _updateContact(Contact updatedContact) async {
    await _contactsProvider.updateContact(updatedContact);
  }

  Future<void> _deleteContact(int id) async {
    await _contactsProvider.deleteContact(id);
  }

  // use this when ever needed.
  // Future<Contact?> _getContact(int id) async {
  //   return await _dbHelper.getContact(id);
  // }

  void _filterContacts(String query) {
    _contactsProvider.filterContacts(query);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 25,
              right: 25,
              top: 5,
              bottom: 20,
            ),
            height: 45,
            child: TextField(
              onChanged: _filterContacts,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    color: Colors.black38,
                  ),
                ),
                labelText: 'search by name',
                prefixIcon: const Icon(LineIcons.search),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: Colors.black,
                    style: BorderStyle.solid,
                  ),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: Colors.black87,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            // the consumers hey man you changed then we gone change.
            child: Consumer<ContactsProvider>(
              builder: (context, contactsProvider, child) {
                final filteredContacts = contactsProvider.filteredContacts;
                return filteredContacts.isEmpty
                    ? const Center(
                        child: FadingText(
                          message: 'no contacts available.',
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredContacts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Map<String, dynamic> contact =
                              filteredContacts[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 30.0,
                              right: 30.0,
                              bottom: 3.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                UpdateContactDialog.showUpdateDialog(
                                  context,
                                  nameController,
                                  phoneNumberController,
                                  emailConatoller,
                                  Contact.fromMap(contact),
                                  (updatedContact) {
                                    _updateContact(updatedContact);
                                  },
                                );
                              },
                              child: Slidable(
                                startActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) async {
                                        await FlutterPhoneDirectCaller
                                            .callNumber(contact['phoneNumber']);
                                      },
                                      icon: Icons.call,
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.green.shade300,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                    )
                                  ],
                                ),
                                endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        UpdateContactDialog.showUpdateDialog(
                                          context,
                                          nameController,
                                          phoneNumberController,
                                          emailConatoller,
                                          Contact.fromMap(contact),
                                          (updatedContact) {
                                            _updateContact(updatedContact);
                                          },
                                        );
                                      },
                                      icon: Icons.edit,
                                      backgroundColor: Colors.red.shade300,
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        _deleteContact(contact['id']);
                                        SnackbarUtils.showSnackbar(context,
                                            SnackbarMessages.contactDeleted);
                                      },
                                      icon: Icons.delete,
                                      backgroundColor: Colors.red.shade300,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                  ],
                                ),
                                child: SizedBox(
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          contact['imagePath'] == ''
                                              ? CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      Colors.primaries[Random()
                                                          .nextInt(Colors
                                                              .primaries
                                                              .length)],
                                                  child: Text(
                                                    contact['name'][0],
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: contact[
                                                              'imagePath'] !=
                                                          null
                                                      ? FileImage(File(
                                                          contact['imagePath']))
                                                      : null,
                                                ),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Text(
                                            contact['name'],
                                            style: GoogleFonts.montserrat(
                                              textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          )
                                        ],
                                      ),
                                      const Divider(
                                        color: Colors.black12,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
