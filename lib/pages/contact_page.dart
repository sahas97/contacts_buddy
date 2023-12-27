import 'dart:io';
import 'package:contact_buddy/models/contacts_model.dart';
import 'package:contact_buddy/provider/contacts_provider.dart';
import 'package:contact_buddy/validators/utils/snackbar_utils.dart';
import 'package:contact_buddy/validators/messages/snakbar_messages.dart';
import 'package:contact_buddy/widgets/fading_text.dart';
import 'package:contact_buddy/widgets/show_update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';

import '../widgets/show_add_dialog.dart';

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

  // Future<void> _addContact(Contact contact) async {
  //   await _contactsProvider.addContact(contact);
  // }

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
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterContacts,
              decoration: const InputDecoration(
                labelText: 'Search by Name',
                prefixIcon: Icon(Icons.search),
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
                          message: 'No contacts available.',
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredContacts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Map<String, dynamic> contact =
                              filteredContacts[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                              right: 5.0,
                              bottom: 3.0,
                            ),
                            child: Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: contact['imagePath'] != null
                                      ? FileImage(File(contact['imagePath']))
                                      : null,
                                ),
                                title: Text(contact['name']),
                                subtitle: Text(contact['phoneNumber']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteContact(contact['id']);
                                        SnackbarUtils.showSnackbar(
                                          context,
                                          SnackbarMessages.contactDeleted,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
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
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await FlutterPhoneDirectCaller
                                            .callNumber(contact['phoneNumber']);
                                      },
                                      icon: const Icon(Icons.call),
                                    ),
                                  ],
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
