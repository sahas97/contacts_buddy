class InputValidators {
  static bool isValidPhoneNumber(String phoneNumber) {
    return phoneNumber.length == 10 && int.tryParse(phoneNumber) != null;
  }

  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(email);
  }
}
