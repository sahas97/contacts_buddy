import 'package:contact_buddy/provider/calling_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CallingPage extends StatefulWidget {
  const CallingPage({super.key});

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CallingProvider(),
      child: SafeArea(
        child: Consumer<CallingProvider>(
          builder: (context, callingProvider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextField(
                    controller: callingProvider.phoneNumberController,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Enter phone number',
                      hintStyle: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      suffixIcon: callingProvider.isNotEmpty
                          ? IconButton(
                              onPressed: () => callingProvider.clearAll(),
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black54,
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                              callingProvider.appendDigit('*');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              '*',
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (index == 10) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextButton(
                            onPressed: () {
                              callingProvider.appendDigit('0');
                            },
                            style: TextButton.styleFrom(
                              elevation: 0.0,
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              '0',
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (index == 11) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextButton(
                            onPressed: () {
                              callingProvider.appendDigit('#');
                            },
                            style: TextButton.styleFrom(
                              elevation: 0.0,
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              '#',
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      // For other numbers
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextButton(
                          onPressed: () {
                            callingProvider.appendDigit((index + 1).toString());
                          },
                          style: TextButton.styleFrom(
                            elevation: 0.0,
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                          ),
                          child: Text(
                            (index + 1).toString(),
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                fontSize: 24,
                                color: Colors.black54,
                              ),
                            ),
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
                            onPressed: () async =>
                                await callingProvider.makeCall(context),
                            style: TextButton.styleFrom(
                              elevation: 0.0,
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                            ),
                            child: const Icon(
                              Icons.call_outlined,
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
                            onPressed: () {
                              callingProvider.clear();
                            },
                            style: TextButton.styleFrom(
                              elevation: 0.0,
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                            ),
                            child: const Icon(
                              Icons.backspace_outlined,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // void _appendDigit(String digit) {
  //   setState(() {
  //     phoneNumberController.text += digit;
  //   });
  // }

  // void _clear() {
  //   setState(() {
  //     String currentText = phoneNumberController.text;
  //     if (currentText.isNotEmpty) {
  //       phoneNumberController.text =
  //           currentText.substring(0, currentText.length - 1);
  //     }
  //   });
  // }
}
