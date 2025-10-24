import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/banner_ad_widget.dart';
import 'calorie_deficit_plan_screen.dart';

enum Gender { male, female }

extension GenderExtension on Gender {
  String localized(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return this == Gender.male ? loc.genderMale : loc.genderFemale;
  }
}

Route<dynamic> noAnimationRoute(Widget page) => PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();
    _storeCurrentScreen();
  }

  Future<void> _storeCurrentScreen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', 'genderSelectionScreen');
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60, child: BannerAdWidget()),

            Expanded(
              child: Center(
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        loc.genderSelectionTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildGenderOption(Gender.male, Icons.male),
                          const SizedBox(width: 20),
                          _buildGenderOption(Gender.female, Icons.female),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _selectedGender == null
                            ? null
                            : () async {
                                // Guardamos el género y navegamos
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('gender', _selectedGender!.name);
                                await prefs.setString(
                                    'lastScreen', 'calorieDeficitPlanScreen');

                                final user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  await FirebaseFirestore.instance
                                      .collection('usuarios')
                                      .doc(user.uid)
                                      .set(
                                        {'gender': _selectedGender!.name},
                                        SetOptions(merge: true),
                                      );
                                }

                                Navigator.push(
                                  context,
                                  noAnimationRoute(
                                    CalorieDeficitPlanScreen(
                                      gender: _selectedGender!,
                                    ),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 244, 67, 54),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(loc.genderContinueButton),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60, child: BannerAdWidget()),
          ],
        ),
      ),
    );
  }


  Widget _buildGenderOption(Gender value, IconData icon) {
    final isSelected = _selectedGender == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: Column(
        children: [
          Icon(
            icon,
            size: 80,
            color: isSelected
                ? const Color.fromARGB(255, 244, 67, 54)
                : Colors.white,
          ),
          Text(
            value.localized(context),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? const Color.fromARGB(255, 244, 67, 54)
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}