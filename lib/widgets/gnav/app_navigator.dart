import 'package:contact_buddy/models/contacts_model.dart';
import 'package:contact_buddy/widgets/show_add_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../models/contact_list_interface.dart';
import '../../provider/app_bar_icon_provider.dart';
import '../../provider/navigation_provider.dart';
import '../../pages/calling_page.dart';
import '../../pages/contact_page.dart';
import '../../pages/qr_scannner_page.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

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
                    if (context.read<AppBarIconProvider>().currentIcon ==
                        Icons.add) {
                      _showAddContactDialog(context);
                    }
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
            padding: const EdgeInsets.all(15.0),
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
            child: _getPage(navigationProvider.selectedIndex),
          ),
        );
      },
    );
  }

  Widget _getPage(int index) {
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

  void _showAddContactDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    AddContactDialog.showAddDialog(
      context,
      nameController,
      phoneNumberController,
      emailController,
      addContactCallback,
    );
  }

  @override
  void addContactCallback(Contact contact) {
    // Add your logic to handle the new contact
    // You can access the contact parameter here
    // and add it to your data source.
  }
}
