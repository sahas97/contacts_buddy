import 'package:contact_buddy/provider/calling_provider.dart';
import 'package:contact_buddy/provider/contacts_provider.dart';
import 'package:contact_buddy/provider/image_provider.dart';
import 'package:contact_buddy/provider/navigation_provider.dart';
import 'package:contact_buddy/provider/user_contact_provider.dart';
import 'package:contact_buddy/widgets/bottom_nav/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ContactsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserContactProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImagesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppBarIconProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CallingProvider(),
        ),
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
