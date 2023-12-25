import 'package:flutter/material.dart';

class AppBarIconProvider with ChangeNotifier {
  IconData _currentIcon = Icons.search;

  IconData get currentIcon => _currentIcon;

  void setIcon(IconData icon) {
    _currentIcon = icon;
    notifyListeners();
  }
}
