import 'package:contact_buddy/models/contacts_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;
  static const String tableContacts = 'contacts';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnPhoneNumber = 'phoneNumber';
  static const String columnEmail = 'email';
  static const String imagePath = 'imagePath';

  Future<Database?> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    late final dbPath = join(databasesPath, 'contacts_buddy.db');

    return _database ??= await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE $tableContacts($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnPhoneNumber TEXT, $columnEmail TEXT, $imagePath TEXT)',
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
      debugPrint('Error deleting contact: $e');
      return null;
    }
  }
}
