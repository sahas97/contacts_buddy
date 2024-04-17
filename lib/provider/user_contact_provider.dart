import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/contacts_model.dart';

class UserContactProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late Contact _userContact =
      Contact(name: '', phoneNumber: '', eMail: '', imagePath: '');

  Contact get userContact => _userContact;

  bool _isContactSaved = false;
  bool get isContactSaved => _isContactSaved;

  // Fetch user contact data from database
  Future<void> fetchUserContact() async {
    _userContact = await _databaseHelper.getUserContact() ??
        Contact(name: '', phoneNumber: '', eMail: '', imagePath: '');
    notifyListeners();
  }

  // Save or update user contact data
  Future<void> saveOrUpdateUserContact(Contact contact) async {
    if (contact.id == null) {
      await _databaseHelper.addOrUpdateUserContact(contact);
    } else {
      await _databaseHelper.updateContact(contact);
    }
    _isContactSaved = true;
    notifyListeners();
  }
}
