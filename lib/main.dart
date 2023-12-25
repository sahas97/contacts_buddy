import 'package:contact_buddy/pages/calling_page.dart';
import 'package:contact_buddy/provider/contacts_provider.dart';
import 'package:contact_buddy/provider/image_provider.dart';
import 'package:contact_buddy/pages/contact_page.dart';
import 'package:contact_buddy/provider/navigation_provider.dart';
import 'package:contact_buddy/widgets/gnav/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/qr_scannner_page.dart';
import 'provider/app_bar_icon_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 1;
  void bottomNavigation(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> pages = <Widget>[
    const CallingPage(),
    const ContactsList(),
    const QrScannerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ContactsProvider()),
        ChangeNotifierProvider(create: (context) => ImagesProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(
            create: (context) => AppBarIconProvider()), // Added
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contacts Buddy',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AppNavigator(),
      ),
    );
  }
}
