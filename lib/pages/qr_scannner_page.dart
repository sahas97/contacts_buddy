import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../database/database_helper.dart';
import '../models/contacts_model.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../provider/contacts_provider.dart';
import '../widgets/show_add_dialog.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late Contact userContact =
      Contact(name: '', phoneNumber: '', eMail: '', imagePath: '');
  late Future<String?> qrDataFuture;
  String qrResult = "Result will be Hear";

  @override
  void initState() {
    super.initState();
    qrDataFuture = getContact();
  }

  Future<String?> getContact() async {
    userContact = await _databaseHelper.getUserContact() ??
        Contact(name: '', phoneNumber: '', eMail: '', imagePath: '');
    return userContact.name.isEmpty
        ? null
        : '${userContact.name}*${userContact.phoneNumber}*${userContact.eMail}';
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailConatoller = TextEditingController();

  Future<void> _addContact(Contact contact) async {
    await context.read<ContactsProvider>().addContact(contact);
  }

  Future<void> scanQr() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (!mounted) return;
      setState(() {
        qrResult = qrCode.toString();
        log(qrResult);

        // Split the qrResult string using "*" delimiter
        List<String> qrParts = qrResult.split("*");

        // Assign the parts to the respective controllers
        nameController.text = qrParts.isNotEmpty ? qrParts[0] : '';
        phoneNumberController.text = qrParts.length > 1 ? qrParts[1] : '';
        emailConatoller.text = qrParts.length > 2 ? qrParts[2] : '';

        // Show the add contact dialog
        AddContactDialog.showAddDialog(
          context,
          nameController,
          phoneNumberController,
          emailConatoller,
          (newContact) => _addContact(newContact),
        );
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<String?>(
            future: qrDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return snapshot.data != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Scan Me',
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                color: Colors.black45,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: PrettyQrView.data(data: snapshot.data!),
                          ),
                        ],
                      )
                    : Text(
                        'no QR available please add your profile data',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 160,
            height: 50,
            child: ElevatedButton(
              onPressed: scanQr,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              child: Text(
                'Scan QR',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
