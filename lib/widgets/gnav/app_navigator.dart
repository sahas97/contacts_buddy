import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../models/contacts_model.dart';
import '../../provider/contacts_provider.dart';
import '../../provider/navigation_provider.dart';
import '../../pages/calling_page.dart';
import '../../pages/contact_page.dart';
import '../../pages/qr_scannner_page.dart';
import '../show_add_dialog.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailConatoller = TextEditingController();

  Future<void> _addContact(Contact contact) async {
    await context.read<ContactsProvider>().addContact(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Contact Buddy'),
            actions: [
              if (navigationProvider.selectedIndex == 0)
                IconButton(
                  icon: const Icon(Icons.keyboard),
                  onPressed: () {
                    // Handle icon-specific action for Keypad page
                  },
                ),
              if (navigationProvider.selectedIndex == 1)
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Handle icon-specific action for conatct page
                    AddContactDialog.showAddDialog(
                      context,
                      nameController,
                      phoneNumberController,
                      emailConatoller,
                      (newContact) => _addContact(newContact),
                    );
                  },
                ),
              if (navigationProvider.selectedIndex == 2)
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () {
                    // Handle icon-specific action for Scanner page
                  },
                ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              bottom: 15.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black87,
              ),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: GNav(
                  selectedIndex: navigationProvider.selectedIndex,
                  onTabChange: (value) {
                    navigationProvider.setIndex(value);
                  },
                  color: Colors.white,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  tabBorderRadius: 15.0,
                  curve: Curves.easeInCirc,
                  duration: const Duration(
                    milliseconds: 900,
                  ),
                  tabBackgroundColor: Colors.grey.shade800,
                  padding: const EdgeInsets.all(10),
                  haptic: true,
                  activeColor: Colors.white,
                  gap: 8,
                  tabs: const [
                    GButton(
                      icon: Icons.keyboard,
                      text: 'Keypad',
                    ),
                    GButton(
                      icon: Icons.contacts,
                      text: 'Contacts',
                    ),
                    GButton(
                      icon: Icons.qr_code_scanner,
                      text: 'Scanner',
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Center(
            child: getPage(navigationProvider.selectedIndex),
          ),
        );
      },
    );
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return const CallingPage();
      case 1:
        return const ContactsList();
      case 2:
        return const QrScannerPage();
      default:
        return const SizedBox.shrink();
    }
  }
}
