import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'deficit_selection_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'gender_selection_screen.dart';

Route<dynamic> noAnimationRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}

class CalorieDeficitPlanScreen extends StatefulWidget {
  final Gender gender;

  const CalorieDeficitPlanScreen({super.key, required this.gender});

  @override
  CalorieDeficitPlanScreenState createState() => CalorieDeficitPlanScreenState();
}

class CalorieDeficitPlanScreenState extends State<CalorieDeficitPlanScreen> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _storeCurrentScreen();
  }

  Future<void> _storeCurrentScreen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', 'calorieDeficitPlanScreen');
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              localizations.caloriePlanStep1,
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 244, 67, 54),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              localizations.caloriePlanTitle,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 244, 67, 54),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Expanded(
              flex: 6,
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
                          localizations.caloriePlanIntro,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.caloriePlanParagraph1,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.caloriePlanQuestion,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.caloriePlanParagraph2,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.caloriePlanLimitsTitle,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.caloriePlanLimitsMale,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.caloriePlanLimitsFemale,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.caloriePlanHighOrModerate,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.caloriePlanSafety,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.caloriePlanWeightLoss,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.caloriePlanMinimumIntake,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.caloriePlanSustainability,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.caloriePlanConsultProfessional,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
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
                          localizations.caloriePlanCheckbox,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                Transform.translate(
                  offset: const Offset(0, -20),  
                  child: ElevatedButton(
                    onPressed: _isChecked
                      ? () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('lastScreen', 'deficitSelectionScreen');
                          Navigator.push(
                            context,
                            noAnimationRoute(
                              DeficitSelectionScreen(gender: widget.gender),
                            ),
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
                      child: Text(localizations.caloriePlanStartButton),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}