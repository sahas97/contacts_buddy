import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class CallingProvider extends ChangeNotifier {
  final TextEditingController _phoneNumberController = TextEditingController();

  TextEditingController get phoneNumberController => _phoneNumberController;

  bool get isNotEmpty => _phoneNumberController.text.isNotEmpty;

  String get phoneNumber => _phoneNumberController.text;

  void appendDigit(String digit) {
    _phoneNumberController.text += digit;
    notifyListeners();
  }

  void clearAll() {
    _phoneNumberController.clear();
    notifyListeners();
  }

  void clear() {
    if (_phoneNumberController.text.isNotEmpty) {
      _phoneNumberController.text = _phoneNumberController.text
          .substring(0, _phoneNumberController.text.length - 1);
      notifyListeners();
    }
  }

  Future<void> makeCall(BuildContext context) async {
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }
}
