import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class CallingPage extends StatefulWidget {
  const CallingPage({super.key});

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20.0),
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                hintStyle: const TextStyle(fontSize: 18.0),
                suffixIcon: phoneNumberController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () => phoneNumberController.clear(),
                        icon: const Icon(
                          Icons.clear,
                        ),
                      )
                    : null,
              ),
            ),
          ),
          const Spacer(), // Adds flexible space between the text field and the keypad
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 50.0,
                mainAxisSpacing: 0.0,
                childAspectRatio: 1.1,
              ),
              itemCount: 12,
              itemBuilder: (BuildContext context, int index) {
                // Handling the last row
                if (index == 9) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextButton(
                      onPressed: () {
                        _appendDigit('*');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        '*',
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                  );
                } else if (index == 10) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextButton(
                      onPressed: () {
                        _appendDigit('0');
                      },
                      style: TextButton.styleFrom(
                        elevation: 0.0,
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        '0',
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                  );
                } else if (index == 11) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextButton(
                      onPressed: () {
                        _appendDigit('#');
                      },
                      style: TextButton.styleFrom(
                        elevation: 0.0,
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        '#',
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                  );
                }

                // For other numbers
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextButton(
                    onPressed: () {
                      _appendDigit((index + 1).toString());
                    },
                    style: TextButton.styleFrom(
                      elevation: 0.0,
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(fontSize: 24.0),
                    ),
                  ),
                );
              },
            ),
          ),
          //const Spacer(), // Adds flexible space between the keypad and the bottom buttons
          Padding(
            padding: const EdgeInsets.only(
              bottom: 30,
              right: 30,
              left: 30,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextButton(
                      onPressed: () {
                        _clear();
                      },
                      style: TextButton.styleFrom(
                        elevation: 0.0,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                      ),
                      child: const Icon(
                        Icons.backspace_outlined,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextButton(
                      onPressed: () async =>
                          await FlutterPhoneDirectCaller.callNumber(
                        phoneNumberController.text,
                      ),
                      style: TextButton.styleFrom(
                        elevation: 0.0,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                      ),
                      child: const Icon(
                        Icons.call,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _appendDigit(String digit) {
    setState(() {
      phoneNumberController.text += digit;
    });
  }

  void _clear() {
    setState(() {
      String currentText = phoneNumberController.text;
      if (currentText.isNotEmpty) {
        phoneNumberController.text =
            currentText.substring(0, currentText.length - 1);
      }
    });
  }
}
