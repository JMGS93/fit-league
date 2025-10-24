import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gender_selection_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Route<dynamic> noAnimationRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  InformationScreenState createState() => InformationScreenState();
}

class InformationScreenState extends State<InformationScreen> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _guardarPantallaActual();
  }

  Future<void> _guardarPantallaActual() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', 'informationScreen');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const SizedBox.shrink(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              localizations.informationTitle,
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 244, 67, 54),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 7,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          localizations.informationParagraph1,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.informationParagraph2,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.informationParagraph3,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.informationParagraph4,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.informationParagraph5,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.informationParagraph6,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.informationParagraph7,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: Transform.translate(
                offset: const Offset(0, -20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (value) => setState(() => _isChecked = value!),
                          activeColor: const Color.fromARGB(255, 244, 67, 54),
                          checkColor: Colors.white,
                        ),
                        Expanded(
                          child: Text(
                            localizations.informationCheckboxText,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _isChecked
                          ? () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('lastScreen', 'genderSelectionScreen');
                              Navigator.push(
                                context,
                                noAnimationRoute(const GenderSelectionScreen()),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 244, 67, 54),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(localizations.continueButton),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
