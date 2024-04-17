import 'package:contact_buddy/models/contacts_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;
  static const String tableContacts = 'contacts';
  static const String tableUserContact = 'user_contact';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnPhoneNumber = 'phoneNumber';
  static const String columnEmail = 'email';
  static const String imagePath = 'imagePath';
  static const String columnUserId = 'userId'; // Foreign key

  Future<Database?> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    late final dbPath = join(databasesPath, 'contacts_buddy.db');

    return _database ??= await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $tableContacts($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnPhoneNumber TEXT, $columnEmail TEXT, $imagePath TEXT)',
        );
        await db.execute(
          'CREATE TABLE $tableUserContact($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnPhoneNumber TEXT, $columnEmail TEXT,  $imagePath TEXT)',
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchContacts() async {
    try {
      final db = await initDatabase();
      return db!.query(tableContacts);
    } catch (e) {
      debugPrint('Error fetching contacts: $e');
      return [];
    }
  }

  Future<void> addContact(Contact contact) async {
    try {
      final db = await initDatabase();
      await db!.insert(tableContacts, contact.toMap());
    } catch (e) {
      debugPrint('Error inserting contact: $e');
    }
  }

  Future<void> updateContact(Contact contact) async {
    try {
      final db = await initDatabase();
      await db!.update(tableContacts, contact.toMap(),
          where: '$columnId = ?', whereArgs: [contact.id]);
    } catch (e) {
      debugPrint('Error updating contact: $e');
    }
  }

  Future<void> deleteContact(int id) async {
    try {
      final db = await initDatabase();
      await db!.delete(tableContacts, where: '$columnId = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('Error deleting contact: $e');
    }
  }

  Future<Contact?> getContact(int id) async {
    try {
      final db = await initDatabase();
      final List<Map<String, dynamic>> maps = await db!
          .query(tableContacts, where: '$columnId = ?', whereArgs: [id]);

      return maps.isEmpty ? Contact.fromMap(maps.first) : null;
    } catch (e) {
      debugPrint('Error getting contact: $e');
      return null;
    }
  }

  //CRUD for User Contact
  Future<void> addOrUpdateUserContact(Contact contact) async {
    try {
      final db = await initDatabase();
      await db!.transaction((txn) async {
        // Check if a user contact already exists
        final existingContacts = await txn.query(
          tableUserContact,
          where: '$columnId = ?',
          whereArgs: [1], // Check for ID = 1
        );

        if (existingContacts.isNotEmpty) {
          // Update existing contact
          await txn.update(
            tableUserContact,
            contact.toMap(),
            where: '$columnId = ?',
            whereArgs: [1],
          );
        } else {
          // Create new contact with ID = 1
          await txn.insert(
            tableUserContact,
            contact.toMap()
              ..putIfAbsent('id', () => 1), // Set id to 1 if not provided
          );
        }
      });
    } catch (e) {
      debugPrint('Error adding or updating user contact: $e');
    }
  }

  // Get user contact
  Future<Contact?> getUserContact() async {
    try {
      final db = await initDatabase();
      final List<Map<String, dynamic>> userContacts = await db!.query(
        tableUserContact,
        where: '$columnId = ?',
        whereArgs: [1], // Check for ID = 1
      );

      return userContacts.isNotEmpty
          ? Contact.fromMap(userContacts.first)
          : Contact(
              name: '',
              phoneNumber: '',
              imagePath: '',
            );
    } catch (e) {
      debugPrint('Error getting user contact: $e');
      return null;
    }
  }
}
