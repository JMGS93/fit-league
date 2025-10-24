import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/banner_ad_widget.dart';
import 'widgets/interstitial_ad_manager.dart';   
import 'gender_selection_screen.dart';

Route<dynamic> noAnimationRoute(Widget page) => PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );

class DeficitSelectionScreen extends StatefulWidget {
  final Gender gender;
  const DeficitSelectionScreen({super.key, required this.gender});

  @override
  State<DeficitSelectionScreen> createState() => _DeficitSelectionScreenState();
}

class _DeficitSelectionScreenState extends State<DeficitSelectionScreen> {
  final TextEditingController _deficitController = TextEditingController();
  String? _errorText;
  int get _maxDeficit => widget.gender == Gender.male ? 700 : 500;

  late InterstitialAdManager _interstitialAdManager;

  @override
  void initState() {
    super.initState();
    _storeCurrentScreen();

    _interstitialAdManager = InterstitialAdManager()..loadAd();
  }

  Future<void> _storeCurrentScreen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', 'deficitSelectionScreen');
  }

  @override
  void dispose() {
    _deficitController.dispose();
    _interstitialAdManager.dispose(); 
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  final loc = AppLocalizations.of(context)!;
  final screenHeight = MediaQuery.of(context).size.height;

  final bodyTextStyle = GoogleFonts.poppins(fontSize: 16, color: Colors.white);
  final infoTextStyle = GoogleFonts.poppins(fontSize: 14, color: Colors.white);

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
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: Transform.translate(
                  offset: const Offset(0, -120), 
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            loc.deficitSelectionTitle,
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 244, 67, 54),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            loc.deficitSelectionDescription(_maxDeficit),
                            style: bodyTextStyle,
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _deficitController,
                            keyboardType: TextInputType.number,
                            style: bodyTextStyle,
                            decoration: InputDecoration(
                              labelText: loc.deficitSelectionInputLabel,
                              labelStyle: const TextStyle(color: Colors.white70),
                              errorText: _errorText,
                              filled: true,
                              fillColor: Colors.black,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(color: Color.fromARGB(255, 244, 67, 54)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(color: Color.fromARGB(255, 244, 67, 54)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(color: Color.fromARGB(255, 244, 67, 54)),
                              ),
                            ),
                            onChanged: (v) {
                              final d = int.tryParse(v);
                              setState(() {
                                _errorText = (d == null || d < 0 || d > _maxDeficit)
                                    ? loc.deficitSelectionInputError(_maxDeficit)
                                    : null;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _errorText == null && _deficitController.text.isNotEmpty
                                ? () async {
                                    final selectedDeficit = double.parse(_deficitController.text);
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.setDouble('deficit', selectedDeficit);
                                    await prefs.setString('lastScreen', 'homeScreen');

                                    final user = FirebaseAuth.instance.currentUser;
                                    if (user != null) {
                                      await FirebaseFirestore.instance
                                          .collection('usuarios')
                                          .doc(user.uid)
                                          .set({'deficit': selectedDeficit},
                                              SetOptions(merge: true));
                                    }

                                    _interstitialAdManager.showAd(context);

                                    Navigator.push(
                                      context,
                                      noAnimationRoute(
                                        HomeScreen(
                                          gender: widget.gender,
                                          deficit: selectedDeficit,
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 244, 67, 54),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            child: Text(
                              loc.deficitSelectionContinueButton,
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(loc.deficitSelectionInfoMen, style: infoTextStyle),
                          const SizedBox(height: 8),
                          Text(loc.deficitSelectionInfoWomen, style: infoTextStyle),
                        ],
                      ),
                    ),
                  ),
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
}