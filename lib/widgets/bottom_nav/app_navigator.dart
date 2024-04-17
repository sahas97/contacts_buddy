import 'package:contact_buddy/pages/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
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

enum Menu { profile, settings }

enum AnimationStyles { defaultStyle, custom, none }

const List<(AnimationStyles, String)> animationStyleSegments =
    <(AnimationStyles, String)>[
  (AnimationStyles.defaultStyle, 'Default'),
  (AnimationStyles.custom, 'Custom'),
  (AnimationStyles.none, 'None'),
];

class _AppNavigatorState extends State<AppNavigator> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailConatoller = TextEditingController();

  Future<void> _addContact(Contact contact) async {
    await context.read<ContactsProvider>().addContact(contact);
  }

  AnimationStyle? _animationStyle;

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: PopupMenuButton<Menu>(
              popUpAnimationStyle: _animationStyle,
              icon: Image.asset(
                'assets/icons/menu.png',
                width: 25.0,
                height: 25.0,
                color: Colors.black54,
              ),
              splashRadius: 12,
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              onSelected: (Menu item) {
                switch (item.index) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                    break;
                  default:
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                PopupMenuItem<Menu>(
                  value: Menu.profile,
                  child: ListTile(
                    leading: const Icon(
                      Icons.person_outlined,
                      color: Colors.black54,
                    ),
                    title: Text(
                      'Profile',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<Menu>(
                  value: Menu.settings,
                  child: ListTile(
                    leading: const Icon(
                      Icons.settings_outlined,
                      color: Colors.black54,
                    ),
                    title: Text(
                      'Settings',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              if (navigationProvider.selectedIndex == 0)
                IconButton(
                  icon: const Icon(
                    Icons.keyboard,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    // Handle icon-specific action for Keypad page
                  },
                ),
              if (navigationProvider.selectedIndex == 1)
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black54,
                  ),
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
                  icon: const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    // Handle icon-specific action for Scanner page
                  },
                ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navigationProvider.selectedIndex,
            onTap: (value) {
              navigationProvider.setIndex(value);
            },
            selectedLabelStyle: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Colors.black38,
              ),
            ),
            selectedItemColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(LineIcons.tty),
                label: 'keypad',
              ),
              BottomNavigationBarItem(
                icon: Icon(LineIcons.addressBook),
                label: 'contacts',
              ),
              BottomNavigationBarItem(
                icon: Icon(LineIcons.qrcode),
                label: 'scanner',
              ),
            ],
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
