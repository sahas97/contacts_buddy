import 'package:contact_buddy/database/database_helper.dart';
import 'package:contact_buddy/models/contacts_model.dart';
import 'package:flutter/material.dart';

class ContactsProvider extends ChangeNotifier {
  late DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _contactsList = [];
  List<Map<String, dynamic>> filteredContacts = [];

  ContactsProvider() {
    _databaseHelper = DatabaseHelper();
  }

  Future<void> fetchContacts() async {
    final contacts = await _databaseHelper.fetchContacts();
    _contactsList = contacts;
    _applyFilter(); // Ensure the filter is applied after fetching
    notifyListeners();
  }

  Future<void> addContact(Contact contact) async {
    await _databaseHelper.addContact(contact);
    await fetchContacts();
  }

  Future<void> updateContact(Contact updatedContact) async {
    await _databaseHelper.updateContact(updatedContact);
    await fetchContacts();
  }

  Future<void> deleteContact(int id) async {
    await _databaseHelper.deleteContact(id);
    await fetchContacts();
  }

  void filterContacts(String query) {
    _applyFilter(query);
    notifyListeners();
  }

  void _applyFilter([String query = '']) {
    filteredContacts = _contactsList
        .where((contact) =>
            contact['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
