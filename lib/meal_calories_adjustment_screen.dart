import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/banner_ad_widget.dart';
import 'widgets/interstitial_ad_manager.dart';
import 'dart:developer' as developer;
import 'gender_selection_screen.dart';

class MealCaloriesAdjustmentScreen extends StatefulWidget {
  final Gender gender;
  final double deficit;

  const MealCaloriesAdjustmentScreen({
    super.key,
    required this.gender,
    required this.deficit,
  });

  @override
  MealCaloriesAdjustmentScreenState createState() =>
      MealCaloriesAdjustmentScreenState();
}

class MealCaloriesAdjustmentScreenState
    extends State<MealCaloriesAdjustmentScreen> {
  final TextEditingController _breakfastController = TextEditingController();
  final TextEditingController _lunchController = TextEditingController();
  final TextEditingController _snackController = TextEditingController();
  final TextEditingController _dinnerController = TextEditingController();

  late InterstitialAdManager _interstitialAdManager;
  
  @override
  void initState() {
    super.initState();
    _interstitialAdManager = InterstitialAdManager();
    _interstitialAdManager.loadAd();
  }

  @override
  void dispose() {
    _breakfastController.dispose();
    _lunchController.dispose();
    _snackController.dispose();
    _dinnerController.dispose();
    _interstitialAdManager.dispose();
    super.dispose();
  }

  void _saveAdjustments() async {
    final loc = AppLocalizations.of(context)!;
    final int? breakfast = int.tryParse(_breakfastController.text);
    final int? lunch     = int.tryParse(_lunchController.text);
    final int? snack     = int.tryParse(_snackController.text);
    final int? dinner    = int.tryParse(_dinnerController.text);
    if (breakfast == null || lunch == null || snack == null || dinner == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.mealCaloriesInvalidInput)),
      );
      return;
    }
    final double baseCalories = widget.gender == Gender.male ? 2800.0 : 2200.0;
    final double allowedCalories = baseCalories - widget.deficit;
    final int assignedTotal = breakfast + lunch + snack + dinner;
    if (assignedTotal > allowedCalories) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.mealCaloriesExcess(assignedTotal, allowedCalories)),
        ),
      );
      return;
    }
    if (assignedTotal < allowedCalories) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.mealCaloriesShortfall(assignedTotal, allowedCalories)),
        ),
      );
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("desayunoCalories", breakfast);
    await prefs.setInt("almuerzoCalories", lunch);
    await prefs.setInt("meriendaCalories", snack);
    await prefs.setInt("cenaCalories", dinner);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).update({
          'desayunoCalories': breakfast,
          'almuerzoCalories': lunch,
          'meriendaCalories': snack,
          'cenaCalories': dinner,
          'menuAdjustedManually': true,
          'manualDeficit': widget.deficit,
        });
      } catch (e, st) {
        developer.log('Error updating user document: $e', stackTrace: st);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.mealCaloriesSaved)),
    );
    _interstitialAdManager.showAd(context);

    Navigator.of(context).pop({
      "desayunoCalories": breakfast,
      "almuerzoCalories": lunch,
      "meriendaCalories": snack,
      "cenaCalories": dinner,
    });
  }

  Widget _buildCalorieField(String label, TextEditingController c) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          loc.mealCaloriesAdjustmentTitle,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(height: 60, width: double.infinity, child: BannerAdWidget()),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.mealCaloriesAdjustmentDescription,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  _buildCalorieField(loc.breakfast, _breakfastController),
                  const SizedBox(height: 10),
                  _buildCalorieField(loc.lunch, _lunchController),
                  const SizedBox(height: 10),
                  _buildCalorieField(loc.snack, _snackController),
                  const SizedBox(height: 10),
                  _buildCalorieField(loc.dinner, _dinnerController),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveAdjustments,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(loc.saveButton, style: GoogleFonts.poppins(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(loc.cancelButton, style: GoogleFonts.poppins(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(height: 60, width: double.infinity, child: BannerAdWidget()),
        ],
      ),
    );
  }
}