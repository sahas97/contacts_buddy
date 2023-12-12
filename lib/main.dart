import 'package:contact_buddy/provider/contacts_provider.dart';
import 'package:contact_buddy/provider/image_provider.dart';
import 'package:contact_buddy/screens/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ContactsProvider()),
        ChangeNotifierProvider(create: (context) => ImagesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contacts Buddy',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ContactsList(),
      ),
    );
  }
}
